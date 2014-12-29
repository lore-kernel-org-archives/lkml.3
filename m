Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaL2BFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:05:34 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:63565 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaL2BFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:05:31 -0500
MIME-Version: 1.0
Date: Sun, 28 Dec 2014 17:05:30 -0800
X-Google-Sender-Auth: WQ5aPyaw833VqzdI-yo5tud3H_E
Message-ID: <CA+55aFzwiw7c6jigCBD2To+gep6RNiXfPE7jdau1bytk_Hmj9g@mail.gmail.com>
Subject: Linux 3.19-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This -rc is tiny, for all the obvious reasons.

I don't expect that to last, but we'll probably have another week of
relative calm until things really start normalizing.

Aboit 80% drivers (drm being the bulk of it by far), with a few small
fixes around arm64, auditing and some random small oneliners
elsewhere.

                            Linus

---

Al Viro (1):
      [regression] braino in "lustre: use is_root_inode()"

Alexey Skidanov (1):
      amdkfd: init aperture once per process

Catalin Marinas (1):
      arm64: Replace set_arch_dma_coherent_ops with arch_setup_dma_ops

Chris Wilson (3):
      drm/i915: Invalidate media caches on gen7
      drm/i915: Force the CS stall for invalidate flushes
      drm/i915: Disable PSMI sleep messages on all rings around context switches

Corey Minyard (2):
      ipmi: Finish cleanup of BMC attributes
      ipmi: Fix compile issue with isspace()

Dave Airlie (2):
      nouveau: bring back legacy mmap handler
      Revert "drm/gem: Warn on illegal use of the dumb buffer interface v2"

Dave Jones (1):
      agp: Fix up email address & attributions in AGP MODULE_AUTHOR tags

Imre Deak (3):
      drm/i915: vlv: fix IRQ masking when uninstalling interrupts
      drm/i915: move RPS PM_IER enabling to gen6_enable_rps_interrupts
      drm/i915: sanitize RPS resetting during GPU reset

Jilai Wang (2):
      drm/msm/hdmi: enable regulators before clocks to avoid warnings
      drm/msm/hdmi: rework HDMI IRQ handler

Joe Thornber (2):
      dm thin: fix inability to discard blocks when in out-of-data-space mode
      dm thin: fix missing out-of-data-space to write mode transition
if blocks are released

John David Anglin (1):
      parisc: fix out-of-register compiler error in ldcw inline
assembler function

Jungseok Lee (1):
      arm64: mm: Add pgd_page to support RCU fast_gup

Kirill A. Shutemov (1):
      Revert "mm/memory.c: share the i_mmap_rwsem"

Libin Yang (1):
      ALSA: hda_intel: apply the Seperate stream_tag for Skylake

Lorenzo Pieralisi (1):
      arm64: kernel: fix __cpu_suspend mm switch on warm-boot

Marc Dionne (1):
      dm thin: fix crash by initializing thin device's refcount and
completion earlier

Markus Elfring (2):
      drm/msm: Deletion of unnecessary checks before two function calls
      drm/msm: Deletion of unnecessary checks before the function call
"release_firmware"

Oded Gabbay (3):
      drm/amd: Add get_fw_version to kfd-->kgd interface
      drm/radeon: Add implementation of get_fw_version
      amdkfd: Display MEC fw version in topology node

Paolo Bonzini (3):
      kvm: x86: drop severity of "generation wraparound" message
      kvm: fix sorting of memslots with base_gfn == 0
      kvm: warn on more invariant breakage

Paul Moore (2):
      audit: don't attempt to lookup PIDs when changing PID filtering
audit rules
      audit: correctly record file names with different path name types

Rafal Redzimski (1):
      ALSA: hda_controller: Separate stream_tag for input and output streams.

Richard Guy Briggs (2):
      audit: use supplied gfp_mask from audit_buffer in
kauditd_send_multicast_skb
      audit: restore AUDIT_LOGINUID unset ABI

Rob Clark (3):
      drm/atomic: fix potential null ptr on plane enable
      drm/msm: block incoming update on pending updates
      drm/msm/mdp5: update irqs on crtc<->encoder link change

Sean Paul (1):
      drm/tegra: dc: Select root window for event dispatch

Thierry Reding (7):
      drm/irq: Add drm_crtc_send_vblank_event()
      drm/irq: Add drm_crtc_handle_vblank()
      drm/irq: Add drm_crtc_vblank_count()
      drm/tegra: dc: Consistently use the same pipe
      drm/tegra: dc: Fix a potential race on page-flip completion
      drm/tegra: gem: Flush buffer objects upon allocation
      drm/tegra: gem: Use the proper size for GEM objects

Tiejun Chen (1):
      kvm: x86: vmx: reorder some msr writing

Will Deacon (1):
      arm64: defconfig: defconfig update for 3.19

zhendong chen (1):
      dm: fix missed error code if .end_io isn't implemented by target_type
