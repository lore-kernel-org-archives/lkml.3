Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbbAOJyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:54:00 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41767 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbbAOJxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:53:53 -0500
Message-ID: <54B78E2D.3040601@suse.cz>
Date: Thu, 15 Jan 2015 10:53:49 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.36
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 3.12.36 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

----------------------------------------------------------------
Alexander Kochetkov (2):
      i2c: omap: fix NACK and Arbitration Lost irq handling
      i2c: omap: fix i207 errata handling

Andreas Müller (1):
      mac80211: fix multicast LED blinking and counter

Andrew Morton (1):
      mm/vmpressure.c: fix race in vmpressure_work_fn()

Andy Lutomirski (4):
      x86/tls: Validate TLS entries to protect espfix
      x86/tls: Disallow unusual TLS segments
      x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
      x86/tls: Don't validate lm in set_thread_area() after all

Anton Blanchard (1):
      powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Baruch Siach (1):
      mmc: block: add newline to sysfs display of force_ro

Dan Carpenter (1):
      dm space map metadata: fix sm_bootstrap_get_nr_blocks()

Daniel Borkmann (1):
      net: sctp: use MAX_HEADER for headroom reserve in output path

Daniel Forrest (1):
      mm: fix anon_vma_clone() error treatment

Daniel Vetter (2):
      drm/i915: More cautious with pch fifo underruns
      drm/i915: Unlock panel even when LVDS is disabled

Darrick J. Wong (1):
      dm bufio: fix memleak when using a dm_buffer's inline bio

Devin Ryles (1):
      AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Dmitry Eremin-Solenikov (1):
      mfd: tc6393xb: Fail ohci suspend if full state restore is required

Dmitry Torokhov (1):
      sata_fsl: fix error handling of irq_of_parse_and_map

Eric Dumazet (1):
      net: mvneta: fix race condition in mvneta_tx()

Eric W. Biederman (13):
      mnt: Implicitly add MNT_NODEV on remount when it was implicitly added by mount
      mnt: Update unprivileged remount test
      umount: Disallow unprivileged mount force
      groups: Consolidate the setgroups permission checks
      userns: Document what the invariant required for safe unprivileged mappings.
      userns: Don't allow setgroups until a gid mapping has been setablished
      userns: Don't allow unprivileged creation of gid mappings
      userns: Check euid no fsuid when establishing an unprivileged uid mapping
      userns: Only allow the creator of the userns unprivileged mappings
      userns: Rename id_map_mutex to userns_state_mutex
      userns: Add a knob to disable setgroups on a per user namespace basis
      userns: Allow setting gid_maps without privilege when setgroups is disabled
      userns: Unbreak the unprivileged remount tests

Filipe Manana (1):
      Btrfs: fix fs corruption on transaction abort if device supports discard

Francesco Ruggeri (1):
      tty: Fix pty master poll() after slave closes v2

Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received

Hannes Reinecke (1):
      scsi: correct return values for .eh_abort_handler implementations

Hugh Dickins (2):
      mm: fix swapoff hang after page migration and fork
      mm: let mm_find_pmd fix buggy race with THP fault

Jack Morgenstein (1):
      net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

Jan Kara (4):
      isofs: Fix infinite looping over CE entries
      isofs: Fix unchecked printing of ER records
      ncpfs: return proper error from NCP_IOC_SETROOT ioctl
      udf: Verify symlink size before loading it

Jiri Slaby (1):
      Linux 3.12.36

Johan Hovold (1):
      mfd: viperboard: Fix platform-device id collision

Johannes Berg (1):
      mac80211: free management frame keys when removing station

Josef Bacik (1):
      Btrfs: do not move em to modified list when unpinning

Kan Liang (1):
      perf/x86/intel: Protect LBR and extra_regs against KVM lying

Kirill A. Shutemov (1):
      thp: close race between split and zap huge pages

Linus Walleij (1):
      mfd: stmpe: Fix STMPE24xx GPMR LSB

Luis Henriques (1):
      thermal: Fix error path in thermal_init()

Marcelo Leitner (1):
      Fix race condition between vxlan_sock_add and vxlan_sock_release

Martin Schwidefsky (2):
      s390/3215: fix hanging console issue
      s390/3215: fix tty output containing tabs

Mathias Nyman (1):
      USB: xhci: Reset a halted endpoint immediately when we encounter a stall.

Michael Halcrow (1):
      eCryptfs: Remove buggy and unnecessary write in file name decode routine

Nicolas Dichtel (1):
      rtnetlink: release net refcnt on error in do_setlink()

Oleg Nesterov (1):
      exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting

Peng Tao (1):
      nfs41: fix nfs4_proc_layoutget error handling

Peter Zijlstra (1):
      perf/x86: Correctly use FEATURE_PDCM

Petr Mladek (1):
      drm/radeon: kernel panic in drm_calc_vbltimestamp_from_scanoutpos with 3.18.0-rc6

Rabin Vincent (1):
      crypto: af_alg - fix backlog handling

Richard Guy Briggs (2):
      audit: change decimal constant to macro for invalid uid
      audit: restore AUDIT_LOGINUID unset ABI

Ronald Wahl (1):
      usb: gadget: at91_udc: move prepare clk into process context

Sakari Ailus (1):
      media: smiapp: Only some selection targets are settable

Seth Forshee (1):
      xen-netfront: Remove BUGs on paged skb data which crosses a page boundary

Sumit.Saxena@avagotech.com (1):
      megaraid_sas: corrected return of wait_event from abort frame path

Takashi Iwai (4):
      ALSA: hda - Add EAPD fixup for ASUS Z99He laptop
      ALSA: hda - Fix built-in mic at resume on Lenovo Ideapad S210
      ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery
      KEYS: Fix stale key registration at error path

Tejun Heo (1):
      ahci: disable MSI on SAMSUNG 0xa800 SSD

Thadeu Lima de Souza Cascardo (1):
      tg3: fix ring init when there are more TX than RX channels

Todd Fujinaka (1):
      igb: bring link up when PHY is powered up

Tyler Hicks (1):
      eCryptfs: Force RO mount when encrypted view is enabled

Weijie Yang (1):
      mm: frontswap: invalidate expired data on a dup-store failure

Yan, Zheng (1):
      ceph: fix null pointer dereference in discard_cap_releases()

Yuri Chislov (1):
      ipv6: gre: fix wrong skb->protocol in WCCP

willy tarreau (1):
      net: mvneta: fix Tx interrupt delay

 Makefile                                     |   2 +-
 arch/powerpc/kernel/vdso32/getcpu.S          |   4 +-
 arch/s390/kernel/compat_linux.c              |   2 +-
 arch/x86/include/uapi/asm/ldt.h              |   7 +
 arch/x86/kernel/cpu/perf_event.c             |   3 +
 arch/x86/kernel/cpu/perf_event.h             |  12 +-
 arch/x86/kernel/cpu/perf_event_intel.c       |  71 +++++-
 arch/x86/kernel/kvm.c                        |   9 +-
 arch/x86/kernel/kvmclock.c                   |   1 -
 arch/x86/kernel/tls.c                        |  39 ++++
 crypto/af_alg.c                              |   3 +
 drivers/ata/ahci.c                           |   4 +
 drivers/ata/sata_fsl.c                       |   2 +-
 drivers/gpu/drm/i915/intel_display.c         |   2 -
 drivers/gpu/drm/i915/intel_lvds.c            |  22 +-
 drivers/gpu/drm/radeon/radeon_kms.c          |   2 +
 drivers/i2c/busses/i2c-davinci.c             |   8 +-
 drivers/i2c/busses/i2c-omap.c                |  10 +-
 drivers/md/dm-bufio.c                        |  20 +-
 .../persistent-data/dm-space-map-metadata.c  |   4 +-
 drivers/media/i2c/smiapp/smiapp-core.c       |   2 +-
 drivers/mfd/stmpe.h                          |   2 +-
 drivers/mfd/tc6393xb.c                       |  13 +-
 drivers/mfd/viperboard.c                     |   5 +-
 drivers/mmc/card/block.c                     |   2 +-
 drivers/net/ethernet/broadcom/tg3.c          |   3 +-
 drivers/net/ethernet/intel/igb/igb_main.c    |   2 +
 drivers/net/ethernet/marvell/mvneta.c        |   5 +-
 .../mellanox/mlx4/resource_tracker.c         |   2 +-
 drivers/net/vxlan.c                          |  10 +-
 drivers/net/xen-netfront.c                   |   5 -
 drivers/s390/char/con3215.c                  |  52 +++--
 drivers/scsi/NCR5380.c                       |  12 +-
 drivers/scsi/aha1740.c                       |   2 +-
 drivers/scsi/atari_NCR5380.c                 |   2 +-
 drivers/scsi/esas2r/esas2r_main.c            |   2 +-
 drivers/scsi/megaraid.c                      |   8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c    |   2 +-
 drivers/scsi/sun3_NCR5380.c                  |  10 +-
 drivers/thermal/thermal_core.c               |   4 +-
 drivers/tty/n_tty.c                          |   9 +-
 drivers/usb/gadget/at91_udc.c                |  44 +++-
 drivers/usb/host/xhci-ring.c                 |  40 +---
 drivers/usb/host/xhci.c                      |  60 ++---
 fs/btrfs/disk-io.c                           |   6 -
 fs/btrfs/extent-tree.c                       |  10 +-
 fs/btrfs/extent_map.c                        |   2 -
 fs/ceph/mds_client.c                         |  21 +-
 fs/ecryptfs/crypto.c                         |   1 -
 fs/ecryptfs/file.c                           |  12 -
 fs/ecryptfs/main.c                           |  16 +-
 fs/isofs/rock.c                              |   9 +
 fs/namespace.c                               |  11 +-
 fs/ncpfs/ioctl.c                             |   1 -
 fs/nfs/nfs4proc.c                            |   6 +-
 fs/proc/base.c                               |  53 +++++
 fs/udf/symlink.c                             |  17 +-
 include/linux/audit.h                        |   4 +
 include/linux/cred.h                         |   1 +
 include/linux/user_namespace.h               |  12 +
 include/uapi/linux/audit.h                   |   2 +
 kernel/auditfilter.c                         |  12 +-
 kernel/groups.c                              |  11 +-
 kernel/pid.c                                 |   2 +
 kernel/uid16.c                               |   2 +-
 kernel/user.c                                |   1 +
 kernel/user_namespace.c                      | 125 +++++++++-
 mm/frontswap.c                               |   4 +-
 mm/huge_memory.c                             |  31 ++-
 mm/ksm.c                                     |   1 -
 mm/memory.c                                  |  26 +--
 mm/migrate.c                                 |   2 -
 mm/mmap.c                                    |  10 +-
 mm/rmap.c                                    |  18 +-
 mm/vmpressure.c                              |   8 +-
 net/core/rtnetlink.c                         |   1 +
 net/ipv6/ip6_gre.c                           |   4 +-
 net/mac80211/key.c                           |   2 +-
 net/mac80211/rx.c                            |  11 +-
 net/sctp/output.c                            |   4 +-
 security/keys/encrypted-keys/encrypted.c     |   5 +-
 sound/pci/hda/patch_analog.c                 |   1 +
 sound/pci/hda/patch_realtek.c                |   1 +
 sound/usb/midi.c                             |   2 +
 .../mount/unprivileged-remount-test.c        | 204 ++++++++++++++---
 85 files changed, 857 insertions(+), 340 deletions(-)


thanks,
-- 
js
