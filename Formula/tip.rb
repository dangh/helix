class Tip < Formula
  desc "A post-modern modal text editor (tip/development version)"
  homepage "https://helix-editor.com"
  license "MPL-2.0"

  on_macos do
    on_intel do
      url "https://github.com/dangh/helix/releases/download/tip/helix-tip-x86_64-macos.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_arm do
      url "https://github.com/dangh/helix/releases/download/tip/helix-tip-aarch64-macos.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dangh/helix/releases/download/tip/helix-tip-x86_64-linux.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_arm do
      url "https://github.com/dangh/helix/releases/download/tip/helix-tip-aarch64-linux.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    # Install runtime files first
    libexec.install "runtime"
    
    # Create a wrapper script for the binary
    (bin/"hx").write <<~EOS
      #!/bin/bash
      export HELIX_RUNTIME="#{libexec}/runtime"
      exec "#{libexec}/hx" "$@"
    EOS
    
    # Install the actual binary to libexec
    libexec.install "hx"
    
    # Make the wrapper executable
    chmod 0755, bin/"hx"
    
    # Install shell completions if they exist in the archive
    if (buildpath/"contrib/completion").exist?
      bash_completion.install "contrib/completion/hx.bash" => "hx"
      fish_completion.install "contrib/completion/hx.fish"
      zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
    end
  end

  def caveats
    <<~EOS
      This is the development/tip version of Helix built from precompiled binaries.
      For the stable version, use: brew install helix
      
      The runtime files are installed at: #{libexec}/runtime
    EOS
  end

  test do
    # Test basic functionality
    system bin/"hx", "--version"
    system bin/"hx", "--health"
  end
end