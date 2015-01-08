Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbbAHWNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:13:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbbAHWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:13:41 -0500
Date: Thu, 8 Jan 2015 14:13:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.18.2
Message-ID: <20150108221340.GA26486@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.18.2 kernel.

All users of the 3.18 kernel series must upgrade.

The updated 3.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.18.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                                  |    2=20
 arch/arm/boot/dts/armada-370-db.dts                       |   24 -
 arch/arm/boot/dts/armada-370.dtsi                         |   10=20
 arch/arm/include/asm/arch_timer.h                         |    9=20
 arch/arm/mach-mvebu/coherency.c                           |   44 ++-
 arch/arm/mach-mvebu/coherency_ll.S                        |   21 +
 arch/arm/mach-tegra/reset-handler.S                       |    1=20
 arch/arm64/include/asm/arch_timer.h                       |    9=20
 arch/arm64/include/asm/hwcap.h                            |    1=20
 arch/arm64/kernel/setup.c                                 |    3=20
 arch/arm64/net/bpf_jit_comp.c                             |   13=20
 arch/s390/kernel/compat_linux.c                           |    2=20
 arch/x86/include/asm/microcode.h                          |    2=20
 arch/x86/include/asm/microcode_amd.h                      |    4=20
 arch/x86/include/asm/microcode_intel.h                    |    2=20
 arch/x86/include/uapi/asm/ldt.h                           |    7=20
 arch/x86/kernel/cpu/microcode/amd.c                       |    8=20
 arch/x86/kernel/cpu/microcode/amd_early.c                 |   20 +
 arch/x86/kernel/cpu/microcode/core.c                      |   12=20
 arch/x86/kernel/cpu/microcode/core_early.c                |   21 +
 arch/x86/kernel/cpu/microcode/intel_early.c               |   42 ++
 arch/x86/kernel/kvm.c                                     |    9=20
 arch/x86/kernel/kvmclock.c                                |    1=20
 arch/x86/kernel/process_64.c                              |  101 +++++-
 arch/x86/kernel/tls.c                                     |   39 ++
 arch/x86/kernel/traps.c                                   |    5=20
 crypto/af_alg.c                                           |    3=20
 drivers/clocksource/arm_arch_timer.c                      |    5=20
 drivers/gpu/drm/tegra/gem.c                               |   10=20
 drivers/md/dm-bufio.c                                     |   20 +
 drivers/md/dm-cache-target.c                              |   17 -
 drivers/md/dm-crypt.c                                     |    2=20
 drivers/md/dm-thin.c                                      |   30 +-
 drivers/md/persistent-data/dm-space-map-metadata.c        |    4=20
 drivers/mfd/tc6393xb.c                                    |   13=20
 drivers/mfd/twl4030-power.c                               |    3=20
 drivers/mmc/card/block.c                                  |    2=20
 drivers/mmc/host/dw_mmc.c                                 |    7=20
 drivers/mmc/host/omap_hsmmc.c                             |    4=20
 drivers/mmc/host/sdhci-pci-o2micro.c                      |    2=20
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          |    1=20
 drivers/regulator/anatop-regulator.c                      |    8=20
 drivers/scsi/NCR5380.c                                    |   12=20
 drivers/scsi/aha1740.c                                    |    2=20
 drivers/scsi/atari_NCR5380.c                              |    2=20
 drivers/scsi/esas2r/esas2r_main.c                         |    2=20
 drivers/scsi/megaraid.c                                   |    8=20
 drivers/scsi/megaraid/megaraid_sas_base.c                 |    2=20
 drivers/scsi/megaraid/megaraid_sas_fp.c                   |   17 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c               |   13=20
 drivers/scsi/sun3_NCR5380.c                               |   10=20
 drivers/thermal/thermal_core.c                            |    4=20
 fs/btrfs/disk-io.c                                        |   26 +
 fs/btrfs/extent-tree.c                                    |   10=20
 fs/btrfs/extent_map.c                                     |    2=20
 fs/btrfs/ordered-data.c                                   |    9=20
 fs/btrfs/ordered-data.h                                   |    8=20
 fs/btrfs/super.c                                          |    2=20
 fs/btrfs/transaction.c                                    |   33 ++
 fs/btrfs/transaction.h                                    |    2=20
 fs/btrfs/tree-log.c                                       |    6=20
 fs/dcache.c                                               |    2=20
 fs/ecryptfs/crypto.c                                      |    1=20
 fs/ecryptfs/file.c                                        |   12=20
 fs/ecryptfs/main.c                                        |   16 -
 fs/f2fs/data.c                                            |   24 -
 fs/f2fs/segment.c                                         |    2=20
 fs/isofs/rock.c                                           |    9=20
 fs/namespace.c                                            |   13=20
 fs/ncpfs/ioctl.c                                          |    1=20
 fs/nfs/nfs4proc.c                                         |    6=20
 fs/proc/base.c                                            |   53 +++
 fs/udf/dir.c                                              |    3=20
 fs/udf/inode.c                                            |   14=20
 fs/udf/namei.c                                            |    3=20
 fs/udf/symlink.c                                          |   57 +++
 fs/udf/udfdecl.h                                          |    3=20
 fs/udf/unicode.c                                          |   28 +
 include/linux/audit.h                                     |    4=20
 include/linux/cred.h                                      |    1=20
 include/linux/user_namespace.h                            |   12=20
 kernel/audit.c                                            |    8=20
 kernel/auditfilter.c                                      |   23 -
 kernel/groups.c                                           |   11=20
 kernel/pid.c                                              |    2=20
 kernel/uid16.c                                            |    2=20
 kernel/user.c                                             |    1=20
 kernel/user_namespace.c                                   |  122 +++++++-
 mm/cma.c                                                  |   14=20
 net/mac80211/chan.c                                       |   23 +
 net/mac80211/iface.c                                      |    1=20
 net/mac80211/key.c                                        |    2=20
 net/mac80211/mlme.c                                       |    1=20
 net/mac80211/rx.c                                         |   11=20
 security/keys/encrypted-keys/encrypted.c                  |    5=20
 tools/testing/selftests/mount/unprivileged-remount-test.c |  204 +++++++++=
++---
 96 files changed, 1076 insertions(+), 331 deletions(-)

Andreas M=FCller (1):
      mac80211: fix multicast LED blinking and counter

Andy Lutomirski (6):
      x86/tls: Validate TLS entries to protect espfix
      x86/tls: Disallow unusual TLS segments
      x86_64, switch_to(): Load TLS descriptors before switching DS and ES
      x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
      x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync=
_regs
      x86/tls: Don't validate lm in set_thread_area() after all

Baruch Siach (1):
      mmc: block: add newline to sysfs display of force_ro

Boris Ostrovsky (1):
      x86, microcode: Don't initialize microcode code on paravirt

Borislav Petkov (4):
      x86, microcode, AMD: Do not use smp_processor_id() in preemtible cont=
ext
      x86, microcode, intel: Drop unused parameter
      x86, microcode: Reload microcode on resume
      x86/microcode/intel: Fish out the stashed microcode for the BSP

Catalin Marinas (1):
      arm64: Add COMPAT_HWCAP_LPAE

Dan Carpenter (1):
      dm space map metadata: fix sm_bootstrap_get_nr_blocks()

Darrick J. Wong (1):
      dm bufio: fix memleak when using a dm_buffer's inline bio

David Sterba (1):
      btrfs: fix wrong accounting of raid1 data profile in statfs

Dmitry Eremin-Solenikov (1):
      mfd: tc6393xb: Fail ohci suspend if full state restore is required

Dmitry Osipenko (1):
      ARM: tegra: Re-add removed SoC id macro to tegra_resume()

Eric W. Biederman (14):
      mnt: Fix a memory stomp in umount
      mnt: Implicitly add MNT_NODEV on remount when it was implicitly added=
 by mount
      mnt: Update unprivileged remount test
      umount: Disallow unprivileged mount force
      groups: Consolidate the setgroups permission checks
      userns: Document what the invariant required for safe unprivileged ma=
ppings.
      userns: Don't allow setgroups until a gid mapping has been setablished
      userns: Don't allow unprivileged creation of gid mappings
      userns: Check euid no fsuid when establishing an unprivileged uid map=
ping
      userns: Only allow the creator of the userns unprivileged mappings
      userns: Rename id_map_mutex to userns_state_mutex
      userns: Add a knob to disable setgroups on a per user namespace basis
      userns: Allow setting gid_maps without privilege when setgroups is di=
sabled
      userns: Unbreak the unprivileged remount tests

Felix Fietkau (1):
      mac80211: copy chandef from AP vif to VLANs

Filipe Manana (1):
      Btrfs: fix fs corruption on transaction abort if device supports disc=
ard

Greg Kroah-Hartman (1):
      Linux 3.18.2

Hannes Reinecke (1):
      scsi: correct return values for .eh_abort_handler implementations

Hante Meuleman (1):
      brcmfmac: Fix bitmap malloc bug in msgbuf.

James Hogan (1):
      mmc: dw_mmc: avoid write to CDTHRCTL on older versions

Jan Kara (9):
      isofs: Fix infinite looping over CE entries
      f2fs: avoid returning uninitialized value to userspace from f2fs_trim=
_fs()
      f2fs: fix possible data corruption in f2fs_write_begin()
      isofs: Fix unchecked printing of ER records
      ncpfs: return proper error from NCP_IOC_SETROOT ioctl
      udf: Check path length when reading symlink
      udf: Verify i_size when loading inode
      udf: Verify symlink size before loading it
      udf: Check component length before reading it

Jes Sorensen (1):
      mac80211: avoid using uninitialized stack data

Joe Thornber (5):
      dm cache: only use overwrite optimisation for promotion when in write=
back mode
      dm cache: dirty flag was mistakenly being cleared when promoting via =
overwrite
      dm cache: fix spurious cell_defer when dealing with partial block at =
end of device
      dm thin: fix inability to discard blocks when in out-of-data-space mo=
de
      dm thin: fix missing out-of-data-space to write mode transition if bl=
ocks are released

Johannes Berg (1):
      mac80211: free management frame keys when removing station

Joonsoo Kim (1):
      mm/CMA: fix boot regression due to physical address of high_memory

Josef Bacik (3):
      Btrfs: make sure we wait on logged extents when fsycning two subvols
      Btrfs: do not move em to modified list when unpinning
      Btrfs: make sure logged extents complete in the current transaction V3

Luis Henriques (1):
      thermal: Fix error path in thermal_init()

Markus Pargmann (1):
      regulator: anatop: Set default voltage selector for vddpu

Michael Halcrow (1):
      eCryptfs: Remove buggy and unnecessary write in file name decode rout=
ine

Mikulas Patocka (2):
      dcache: fix kmemcheck warning in switch_names
      dm thin: fix a race in thin_dtr

Milan Broz (1):
      dm crypt: use memzero_explicit for on-stack buffer

Oleg Nesterov (1):
      exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiti=
ng

Paul Moore (1):
      audit: don't attempt to lookup PIDs when changing PID filtering audit=
 rules

Peng Tao (1):
      nfs41: fix nfs4_proc_layoutget error handling

Peter Guo (1):
      mmc: sdhci-pci-o2micro: Fix Dell E5440 issue

Rabin Vincent (1):
      crypto: af_alg - fix backlog handling

Richard Guy Briggs (2):
      audit: use supplied gfp_mask from audit_buffer in kauditd_send_multic=
ast_skb
      audit: restore AUDIT_LOGINUID unset ABI

Sonny Rao (1):
      clocksource: arch_timer: Fix code to use physical timers when request=
ed

Sumit.Saxena@avagotech.com (2):
      megaraid_sas: corrected return of wait_event from abort frame path
      megaraid_sas: dndinaness related bug fixes

Takashi Iwai (1):
      KEYS: Fix stale key registration at error path

Thierry Reding (1):
      drm/tegra: gem: dumb: pitch and size are outputs

Thomas Petazzoni (3):
      ARM: mvebu: make the coherency_ll.S functions work with no coherency =
fabric
      ARM: mvebu: disable I/O coherency on non-SMP situations on Armada 370=
/375/38x/XP
      ARM: mvebu: remove conflicting muxing on Armada 370 DB

Tony Lindgren (1):
      mfd: twl4030-power: Fix regression with missing compatible flag

Tyler Hicks (1):
      eCryptfs: Force RO mount when encrypted view is enabled

Ulf Hansson (1):
      mmc: omap_hsmmc: Fix UHS card with DDR50 support

Uwe Kleine-K=F6nig (1):
      ARM: mvebu: fix ordering in Armada 370 .dtsi

Zi Shen Lim (1):
      arm64: bpf: lift restriction on last instruction


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUrwEUAAoJEDjbvchgkmk+7xUQAJR172ZTKBR0v1TS1IsVaKT+
IvaRkqbuMeEfWrONvnLtxqOxF6etW/b9feKhezbTB1X2IXJfdtgAzx4FaY8tqKu+
9+kt3ImdTF0hHMil1zC43qJ+dSiu9aLNca2hcE0v6WnSIv/mC4/48pttTdxfV6b+
IadxNryyFOCaM/cF6+cGhe9jdY3Xi8X6rrLq0SfXrW8PPcifrq+i4NelgdS/9scb
WmQXOUGZvArtyQM8s4gYr6JCwMi/LrrouPVtTwbqVDj/60qm1kuY+cDgSTK9oMbw
xnjg51lsjDejujc/OqLt2oNo80AdfXR5IRJrkrzlKBrRyHPlDRWfKTAoM/4VjVcJ
TTrSzNKYqovoxd9g8YVSCVeiylnpMSblr+a6jKhj2MwtQE4QPbK1DtjIuvVsR/O6
nmeHfxMuq5G+KBhuwvN5Dc11LdVEASoAt9IqtZmv5+vg0xeE9zwlFrygGuAcepi2
SPYjQ9GxW/BNIwclGgTirZE1Knt1pqn6IjtC9HGwaJBXyN/LSsT0Vjh8Cd57UCIr
FEA7mcFCRmVmYajZVx+3LYJnuwY3KCQRA0w/t+ETsKb6Do9dBHrOljZv1Mps4Xgf
AMPiiI5oqDEbW1syYADiMcBB8Y1HNMZd0aIQwK5hNhqiCDKkzbULzlf0IWF74Iqd
sDq5fP/ZVs808Ow1XT65
=SKku
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
