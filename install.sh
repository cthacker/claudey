#!/bin/bash
#
# Claude Agents Installation Script
# Installs Claude agent configurations from this repository to ~/.claude/agents/
#
# Requirements: Bash shell, basic Unix utilities (mkdir, cp, etc.)
# Platform: macOS and Linux (POSIX-compliant)
#

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Script configuration
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly AGENTS_SOURCE_DIR="${SCRIPT_DIR}/agents"
readonly CLAUDE_AGENTS_DIR="${HOME}/.claude/agents"

# Color codes for output (if terminal supports it)
if [[ -t 1 ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly NC='\033[0m' # No Color
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly NC=''
fi

# Error handling and cleanup
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        error "Installation failed with exit code $exit_code"
        error "Run '$SCRIPT_NAME --help' for usage information"
    fi
    exit $exit_code
}

# Set up trap for cleanup
trap cleanup EXIT

# Logging functions
log() {
    echo -e "${BLUE}[INFO]${NC} $*" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" >&2
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $*" >&2
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Display usage information
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS]

Install Claude agent configurations from this repository to ~/.claude/agents/

OPTIONS:
    -h, --help      Show this help message and exit
    -v, --version   Show version information and exit

EXAMPLES:
    $SCRIPT_NAME                    # Install all agents (interactive mode)

NOTES:
    - The script will create ~/.claude/agents/ if it doesn't exist
    - Existing agents will be automatically backed up before overwriting
    - Use Ctrl+C to cancel installation at any time

For more information, see the README.md file.
EOF
}

# Display version information
version() {
    echo "Claude Agents Installation Script v1.0.0"
    echo "Repository: $(git -C "$SCRIPT_DIR" remote get-url origin 2>/dev/null || echo "local")"
    echo "Commit: $(git -C "$SCRIPT_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")"
}

# Validate environment and prerequisites
validate_environment() {
    log "Validating environment..."

    # Check if agents source directory exists
    if [[ ! -d "$AGENTS_SOURCE_DIR" ]]; then
        error "Agents source directory not found: $AGENTS_SOURCE_DIR"
        error "This script must be run from the repository root directory."
        return 1
    fi

    # Check if there are any agent files to install
    if [[ -z "$(find "$AGENTS_SOURCE_DIR" -maxdepth 1 -type f -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" 2>/dev/null)" ]]; then
        error "No agent files found in $AGENTS_SOURCE_DIR"
        error "The repository appears to be empty or corrupted."
        return 1
    fi

    # Check write permissions to home directory
    if [[ ! -w "$HOME" ]]; then
        error "No write permission to home directory: $HOME"
        error "Cannot create ~/.claude/agents/ directory."
        return 1
    fi

    success "Environment validation passed"
    return 0
}

# Ensure the Claude agents directory exists with proper permissions
ensure_agents_directory() {
    log "Checking if Claude agents directory exists..."

    # Check if ~/.claude directory exists
    if [[ ! -d "${HOME}/.claude" ]]; then
        log "Creating ~/.claude directory..."
        if ! mkdir -p "${HOME}/.claude"; then
            error "Failed to create ~/.claude directory"
            return 1
        fi
        success "Created ~/.claude directory"
    fi

    # Check if ~/.claude/agents directory exists
    if [[ ! -d "$CLAUDE_AGENTS_DIR" ]]; then
        log "Creating Claude agents directory: $CLAUDE_AGENTS_DIR"
        if ! mkdir -p "$CLAUDE_AGENTS_DIR"; then
            error "Failed to create Claude agents directory: $CLAUDE_AGENTS_DIR"
            return 1
        fi
        success "Created Claude agents directory: $CLAUDE_AGENTS_DIR"
    else
        log "Claude agents directory already exists: $CLAUDE_AGENTS_DIR"
        # Verify permissions on existing directory
        if [[ ! -w "$CLAUDE_AGENTS_DIR" ]]; then
            error "No write permission to Claude agents directory: $CLAUDE_AGENTS_DIR"
            return 1
        fi
    fi

    return 0
}

# Create backup of existing agent if it exists
backup_existing_agent() {
    local target_file="$1"
    local filename="$(basename "$target_file")"
    
    if [[ -e "$target_file" || -L "$target_file" ]]; then
        local backup_file="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
        log "Backing up existing agent: $filename -> $(basename "$backup_file")"
        
        if ! mv "$target_file" "$backup_file"; then
            error "Failed to create backup: $backup_file"
            return 1
        fi
        
        success "Backup created: $backup_file"
        return 0
    fi
    
    return 0
}

# Install a single agent file using symlinks
install_single_agent() {
    local source_file="$1"
    local filename="$(basename "$source_file")"
    local target_file="${CLAUDE_AGENTS_DIR}/${filename}"
    
    log "Installing agent: $filename"
    
    # Create symlink to the agent file
    if ! ln -s "$source_file" "$target_file"; then
        error "Failed to create symlink for $filename at $target_file"
        return 1
    fi
    
    # Verify the symlink was created successfully
    if [[ ! -L "$target_file" ]]; then
        error "Symlink for agent $filename was not created at $target_file"
        return 1
    fi
    
    # Verify the symlink points to the correct source file
    local resolved_path
    resolved_path="$(readlink "$target_file")"
    if [[ "$resolved_path" != "$source_file" ]]; then
        error "Symlink for $filename points to wrong location: $resolved_path (expected: $source_file)"
        return 1
    fi
    
    success "Successfully installed agent: $filename (symlinked)"
    return 0
}

# Main installation function
install_agents() {
    log "Starting agent installation process..."
    log "Using symlink approach to keep agents synchronized with repository"
    
    local installed_count=0
    local skipped_count=0
    local failed_count=0
    local backup_count=0
    
    # Find all agent files in the source directory
    local agent_files_list
    agent_files_list="$(find "$AGENTS_SOURCE_DIR" -maxdepth 1 -type f \( -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" \) | sort)"
    
    if [[ -z "$agent_files_list" ]]; then
        error "No agent files found in $AGENTS_SOURCE_DIR"
        return 1
    fi
    
    local agent_count
    agent_count="$(echo "$agent_files_list" | wc -l | tr -d ' ')"
    log "Found $agent_count agent file(s) to install"
    
    # Install each agent file
    while IFS= read -r agent_file; do
        [[ -z "$agent_file" ]] && continue
        local filename="$(basename "$agent_file")"
        
        local target_file="${CLAUDE_AGENTS_DIR}/${filename}"
        
        # Check if target already exists
        if [[ -e "$target_file" || -L "$target_file" ]]; then
            # If it's already a symlink pointing to our source, skip it
            if [[ -L "$target_file" ]]; then
                local current_target
                current_target="$(readlink "$target_file")"
                if [[ "$current_target" == "$agent_file" ]]; then
                    log "Agent $filename already correctly installed (symlink to $agent_file)"
                    ((skipped_count++))
                    continue
                fi
            fi
            
            # It's either a regular file or a symlink to a different location, so back it up
            if backup_existing_agent "$target_file"; then
                ((backup_count++))
            else
                ((failed_count++))
                continue
            fi
        fi
        
        # Install the agent
        if install_single_agent "$agent_file"; then
            ((installed_count++))
        else
            # Installation failed
            ((failed_count++))
        fi
    done <<< "$agent_files_list"
    
    # Report installation summary
    log "Installation summary:"
    log "  - Installed: $installed_count agent(s)"
    if [[ $skipped_count -gt 0 ]]; then
        log "  - Skipped: $skipped_count agent(s)"
    fi
    if [[ $backup_count -gt 0 ]]; then
        log "  - Backed up: $backup_count agent(s)"
    fi
    if [[ $failed_count -gt 0 ]]; then
        log "  - Failed: $failed_count agent(s)"
    fi
    
    if [[ $failed_count -gt 0 ]]; then
        error "Some agents failed to install"
        return 1
    fi
    
    if [[ $installed_count -eq 0 && $skipped_count -eq 0 ]]; then
        error "No agents were processed"
        return 1
    fi
    
    success "Agent installation completed successfully"
    log "Note: Agents are symlinked - updates to the repository will automatically apply"
    return 0
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -v|--version)
                version
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                error "Use '$SCRIPT_NAME --help' for usage information"
                return 1
                ;;
        esac
        shift
    done
}

# Main function
main() {
    log "Starting Claude Agents installation..."
    log "Script: $SCRIPT_NAME"
    log "Source directory: $AGENTS_SOURCE_DIR"
    log "Target directory: $CLAUDE_AGENTS_DIR"

    # Parse command line arguments
    parse_arguments "$@"

    # Validate environment
    validate_environment

    # Ensure Claude agents directory exists
    ensure_agents_directory

    # Install agents
    install_agents

    success "Installation script completed successfully"
}

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
