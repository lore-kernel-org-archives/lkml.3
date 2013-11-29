Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3K2TiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 14:38:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3K2TiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 14:38:02 -0500
Date: Fri, 29 Nov 2013 11:38:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.2
Message-ID: <20131129193855.GA7211@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.2 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/arm/kvm/mmu.c                                  |   34 +++
 arch/arm/mach-omap2/omap_hwmod.c                    |   29 ++-
 arch/cris/include/asm/io.h                          |    1=20
 arch/ia64/include/asm/processor.h                   |    2=20
 arch/powerpc/kernel/eeh.c                           |    9 +
 arch/powerpc/kernel/signal_32.c                     |   10 +
 arch/powerpc/kernel/time.c                          |    4=20
 arch/powerpc/kernel/vio.c                           |    4=20
 arch/powerpc/mm/gup.c                               |    5=20
 arch/powerpc/mm/slice.c                             |    2=20
 arch/powerpc/platforms/512x/mpc512x_shared.c        |    3=20
 arch/powerpc/platforms/52xx/Kconfig                 |    2=20
 arch/powerpc/platforms/powernv/pci-ioda.c           |   12 +
 arch/s390/crypto/aes_s390.c                         |   19 +-
 arch/s390/include/asm/timex.h                       |    6=20
 arch/s390/kernel/smp.c                              |    4=20
 arch/s390/kernel/vtime.c                            |    2=20
 arch/x86/kernel/crash.c                             |    2=20
 arch/x86/kernel/ftrace.c                            |   14 +
 arch/x86/kernel/microcode_amd.c                     |    2=20
 arch/x86/kernel/process.c                           |    6=20
 arch/x86/kernel/reboot.c                            |    8=20
 arch/x86/kvm/emulate.c                              |    5=20
 block/blk-core.c                                    |    1=20
 block/blk-settings.c                                |    1=20
 block/blk-timeout.c                                 |    3=20
 crypto/ansi_cprng.c                                 |    4=20
 drivers/acpi/ec.c                                   |    3=20
 drivers/acpi/pci_root.c                             |    5=20
 drivers/acpi/processor_idle.c                       |   46 +----
 drivers/acpi/scan.c                                 |    2=20
 drivers/acpi/video.c                                |    2=20
 drivers/block/brd.c                                 |    2=20
 drivers/block/loop.c                                |    2=20
 drivers/bluetooth/btusb.c                           |    1=20
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc1.c |    4=20
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c |    1=20
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd9.c |    1=20
 drivers/gpu/drm/shmobile/Kconfig                    |    1=20
 drivers/hv/channel_mgmt.c                           |    5=20
 drivers/hwmon/lm90.c                                |   11 -
 drivers/idle/intel_idle.c                           |    2=20
 drivers/memstick/core/ms_block.c                    |    2=20
 drivers/misc/lkdtm.c                                |   16 +
 drivers/misc/mei/nfc.c                              |   10 -
 drivers/net/can/c_can/c_can.c                       |    6=20
 drivers/net/can/usb/kvaser_usb.c                    |   20 +-
 drivers/net/ethernet/atheros/alx/main.c             |    3=20
 drivers/net/wireless/libertas/debugfs.c             |    6=20
 drivers/net/wireless/rt2x00/rt2800lib.c             |   11 -
 drivers/net/wireless/rt2x00/rt2800usb.c             |   12 -
 drivers/net/wireless/rt2x00/rt2x00dev.c             |    3=20
 drivers/net/wireless/rt2x00/rt2x00lib.h             |    2=20
 drivers/net/wireless/rt2x00/rt2x00mac.c             |    7=20
 drivers/net/wireless/rt2x00/rt2x00queue.c           |    4=20
 drivers/platform/x86/thinkpad_acpi.c                |    7=20
 drivers/scsi/aacraid/commctrl.c                     |    3=20
 drivers/staging/android/ashmem.c                    |    2=20
 drivers/staging/comedi/comedi_fops.c                |    5=20
 drivers/staging/rtl8188eu/os_dep/os_intfs.c         |    5=20
 drivers/staging/zram/zram_drv.c                     |    6=20
 drivers/usb/core/driver.c                           |    3=20
 drivers/usb/core/hub.c                              |   39 ++++
 drivers/usb/core/sysfs.c                            |    6=20
 drivers/usb/host/xhci-mem.c                         |   10 -
 drivers/usb/host/xhci.c                             |  165 ++-------------=
----
 drivers/usb/host/xhci.h                             |    1=20
 drivers/usb/musb/musb_core.c                        |    4=20
 drivers/usb/musb/musb_dsps.c                        |   25 +-
 drivers/usb/musb/musb_virthub.c                     |   19 ++
 drivers/usb/serial/mos7840.c                        |    4=20
 drivers/usb/wusbcore/wa-rpipe.c                     |    5=20
 fs/btrfs/relocation.c                               |   18 +-
 fs/configfs/dir.c                                   |   16 +
 fs/dcache.c                                         |    9 -
 fs/exec.c                                           |    6=20
 fs/gfs2/inode.c                                     |   30 +--
 fs/nfs/nfs4proc.c                                   |   36 +---
 fs/nfs/nfs4state.c                                  |    9 -
 fs/nfsd/export.c                                    |   15 +
 fs/nfsd/nfs4xdr.c                                   |    4=20
 fs/nfsd/vfs.c                                       |  173 +++++++++++----=
-----
 fs/xfs/xfs_sb.c                                     |   13 +
 include/linux/binfmts.h                             |    3=20
 include/linux/nfs4.h                                |    2=20
 include/linux/sched.h                               |   82 ++++++++-
 include/linux/thread_info.h                         |    2=20
 include/linux/usb.h                                 |    4=20
 include/sound/compress_driver.h                     |    9 +
 ipc/shm.c                                           |   37 +++-
 kernel/cpu/idle.c                                   |    9 -
 kernel/ptrace.c                                     |    3=20
 kernel/trace/trace_event_perf.c                     |    2=20
 mm/slub.c                                           |    4=20
 net/sunrpc/auth_gss/auth_gss.c                      |    1=20
 net/sunrpc/clnt.c                                   |   29 +--
 net/sunrpc/xprtsock.c                               |   28 ++-
 security/integrity/ima/ima_policy.c                 |    1=20
 sound/core/compress_offload.c                       |   54 +++++-
 sound/drivers/pcsp/pcsp.c                           |    2=20
 sound/isa/msnd/msnd_pinnacle.c                      |    4=20
 sound/pci/hda/hda_codec.c                           |    7=20
 sound/pci/hda/hda_generic.c                         |   12 -
 sound/pci/hda/hda_generic.h                         |    3=20
 sound/pci/hda/hda_intel.c                           |   14 -
 sound/pci/hda/patch_analog.c                        |    6=20
 sound/pci/hda/patch_cirrus.c                        |   28 +++
 sound/pci/hda/patch_conexant.c                      |    3=20
 sound/pci/hda/patch_realtek.c                       |   83 +++++++++
 sound/usb/6fire/chip.c                              |    2=20
 virt/kvm/iommu.c                                    |    4=20
 112 files changed, 944 insertions(+), 518 deletions(-)

Aaron Lu (1):
      ACPI / video: Quirk initial backlight level 0

Al Viro (1):
      prepend_path() needs to reinitialize dentry/vfsmount/mnt on restarts

Anatolij Gustschin (1):
      powerpc/52xx: fix build breakage for MPC5200 LPBFIFO module

Anton Blanchard (2):
      powerpc: ppc64 address space capped at 32TB, mmap randomisation disab=
led
      powerpc/pseries: Duplicate dtl entries sometimes sent to userspace

Ben Skeggs (1):
      drm/nvc0-/gr: fix a number of missing explicit array terminators...

Christoffer Dall (1):
      arm/arm64: KVM: Fix hyp mappings of vmalloc regions

Christoph Hellwig (2):
      nfsd: split up nfsd_setattr
      nfsd: make sure to balance get/put_write_access

Christoph Lameter (1):
      slub: Handle NULL parameter in kmem_cache_flags

Dan Carpenter (1):
      libertas: potential oops in debugfs

David Henningsson (3):
      ALSA: hda - Make sure mute LEDs stay on during runtime suspend (Realt=
ek)
      ALSA: hda - Fix Line Out automute on Realtek multifunction jacks
      ALSA: hda - Add headset quirk for Dell Inspiron 3135

Eric Sandeen (1):
      xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields

Felix Fietkau (1):
      rt2x00: fix a crash bug in the HT descriptor handling fix

Fenghua Yu (1):
      x86/apic: Disable I/O APIC before shutdown of the local APIC

Gabor Juhos (1):
      rt2x00: rt2800lib: fix VGC adjustment for RT5592

Gavin Shan (2):
      powerpc/powernv: Add PE to its own PELTV
      powerpc/eeh: Enable PCI_COMMAND_MASTER for PCI bridges

Gerhard Sittig (1):
      powerpc/mpc512x: silence build warning upon disabled DIU

Greg Edwards (1):
      KVM: IOMMU: hva align mapping page size

Greg Kroah-Hartman (1):
      Linux 3.12.2

Greg Thelen (1):
      ipc,shm: fix shm_file deletion races

Guenter Roeck (1):
      hwmon: (lm90) Fix max6696 alarm handling

Hans de Goede (1):
      Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops"

Heiko Carstens (1):
      powerpc: Fix __get_user_pages_fast() irq handling

Herbert Xu (1):
      crypto: s390 - Fix aes-cbc IV corruption

Ian Abbott (1):
      staging: comedi: avoid memleak for subdevice private

J. Bruce Fields (3):
      nfsd: return better errors to exportfs
      nfsd4: fix discarded security labels on setattr
      nfsd4: fix xdr decoding of large non-write compounds

Jeff Layton (3):
      nfs: fix inverted test for delegation in nfs4_reclaim_open_state
      nfs: fix oops when trying to set SELinux label
      nfs: don't retry detect_trunking with RPC_AUTH_UNIX more than once

Jeff Moyer (1):
      block: fix race between request completion and timeout handling

Jesper Nilsson (1):
      ipc,shm: correct error return value in shmctl (SHM_UNLOCK)

Johan Hovold (1):
      USB: mos7840: fix tiocmget error handling

John Stultz (1):
      staging: ashmem: Fix ASHMEM_PURGE_ALL_CACHES return value

Josef Bacik (1):
      Btrfs: relocate csums properly with prealloc extents

Julius Werner (1):
      usb: hub: Clear Port Reset Change during init/resume

Junxiao Bi (1):
      configfs: fix race between dentry put and lookup

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in channel rescind code

Kailang Yang (1):
      ALSA: hda - Add support of ALC255 codecs

Kees Cook (2):
      lkdtm: isolate stack corruption test
      exec/ptrace: fix get_dumpable() incorrect tests

Kevin Hao (1):
      ftrace/x86: skip over the breakpoint for ftrace caller

Larry Finger (1):
      staging: r8188eu: Set device type to wlan

Laurent Pinchart (1):
      drm: shmobile: Add dependency on BACKLIGHT_CLASS_DEVICE

Mahesh Rajashekhara (1):
      aacraid: prevent invalid pointer dereference

Markus Pargmann (1):
      can: c_can: Fix RX message handling, handle lost message before EOB

Martin Schwidefsky (2):
      s390/time: fix get_tod_clock_ext inline assembly
      s390/vtime: correct idle time calculation

Mathias Nyman (1):
      xhci: Enable LPM support only for hardwired or BESL devices

Mauro Carvalho Chehab (1):
      cris: media platform drivers: fix build

Michael Neuling (1):
      powerpc/signals: Mark VSX not saved with small contexts

Mike Snitzer (1):
      block: properly stack underlying max_segment_size to DM device

Miklos Szeredi (2):
      GFS2: d_splice_alias() can't return error
      GFS2: fix dentry leaks

Mikulas Patocka (1):
      block: fix a probe argument to blk_register_region

Mimi Zohar (1):
      Revert "ima: policy for RAMFS"

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request

Olivier Sobrie (1):
      can: kvaser_usb: fix usb endpoints detection

Paolo Bonzini (1):
      KVM: x86: fix emulation of "movzbl %bpl, %eax"

Peter Zijlstra (1):
      sched, idle: Fix the idle polling state logic

Prarit Bhargava (1):
      powerpc/vio: use strcpy in modalias_show

Puneet Kumar (1):
      ACPI / EC: Ensure lock is acquired before accessing ec struct members

Rafael J. Wysocki (2):
      ACPI / hotplug: Fix handle_root_bridge_removal()
      ACPI / hotplug: Do not execute "insert in progress" _OST

Rashika Kheria (1):
      Staging: zram: Fix access of NULL pointer

Roger Tseng (1):
      drivers/memstick/core/ms_block.c: fix unreachable state in h_msb_read=
_page()

Sarah Sharp (3):
      usb: Don't enable USB 2.0 Link PM by default.
      xhci: Set L1 device slot on USB2 LPM enable/disable.
      usb: Disable USB 2.0 Link PM before device reset.

Sebastian Andrzej Siewior (5):
      usb: musb: cancel work on removal
      usb: musb: call musb_start() only once in OTG mode
      usb: musb: dsps: move try_idle to start hook
      usb: musb: dsps: redo the otg timer
      usb: musb: core: properly free host / device structs in err path

Stanislaw Gruszka (3):
      rt2x00: check if device is still available on rt2x00mac_flush()
      rt2x00: fix HT TX descriptor settings regression
      rt2800usb: slow down TX status polling

Steven Rostedt (1):
      perf/ftrace: Fix paranoid level for enabling function tracer

Suman Anna (1):
      ARM: OMAP2+: hwmod: check for module address space during init

Takashi Iwai (17):
      thinkpad_acpi: Fix build error when CONFIG_SND_MAX_CARDS > 32
      ALSA: 6fire: Fix probe of multiple cards
      ALSA: pcsp: Fix the order of input device unregistration
      ALSA: hda - Apply GPIO setup for MacBooks with CS4208
      ALSA: hda - Apply MacBook fixups for CS4208 correctly
      ALSA: msnd: Avoid duplicated driver name
      ALSA: hda - Introduce the bitmask for excluding output volume
      ALSA: hda - Enable SPDIF for Acer TravelMate 6293
      ALSA: hda - Force buffer alignment for Haswell HDMI controllers
      ALSA: hda - Add support for CX20952
      ALSA: hda - Add pincfg fixup for ASUS W5A
      ALSA: hda - Check keep_eapd_on before inv_eapd
      ALSA: hda - Don't turn off EAPD for headphone on Lenovo N100
      ALSA: hda - Don't clear the power state at snd_hda_codec_reset()
      ALSA: hda - Fix unbalanced runtime PM notification at resume
      ALSA: hda - Fix the headphone jack detection on Sony VAIO TX
      ALSA: hda - Provide missing pin configs for VAIO with ALC260

Thomas Pugliese (1):
      usb: wusbcore: set the RPIPE wMaxPacketSize value correctly

Thomas Renninger (1):
      x86/microcode/amd: Tone down printk(), don't treat a missing firmware=
 file as an error

Tomas Winkler (1):
      mei: nfc: fix memory leak in error path

Trond Myklebust (7):
      NFSv4.2: Fix a mismatch between Linux labeled NFS and the NFSv4.2 spec
      NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()
      NFSv4: Fix state reference counting in _nfs4_opendata_reclaim_to_nfs4=
_state
      NFS: Fix a missing initialisation when reading the SELinux label
      SUNRPC: gss_alloc_msg - choose _either_ a v0 message or a v1 message
      SUNRPC: Fix a data corruption issue when retransmitting RPC calls
      SUNRPC: Avoid deep recursion in rpc_release_client

Vinod Koul (2):
      ALSA: compress: fix drain calls blocking other compress functions
      ALSA: compress: fix drain calls blocking other compress functions (v6)

Weston Andros Adamson (3):
      NFSv4: fix NULL dereference in open recover
      NFSv4: don't fail on missing fattr in open recover
      NFSv4: don't reprocess cached open CLAIM_PREVIOUS

hahnjo (1):
      alx: Reset phy speed after resume


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmO1PAAoJEDjbvchgkmk+oyIQALu5hm799rTIezJ6dNBWqe3E
B6cYcryuiwCcOgelrT9M/hfbPVPkmPCyUhUMRxk0/9KdqkBA+/VEh8JRbyNwAUvE
si5/Qgtv1oOnjukSsmm0E2j/+uvlPQcxOWmmi/9OgXIEW3dJ2+o20P2nYx7lF0Vm
CHyXSeWCO148+Vo8zpSySx1aSqKmYtdleW8MQEyB2mjztIadgcX97Q2Xl4X0Pr5A
eeENtuc3J8GJFRy09dRouha/zUDj1ZBsVHkpELiddis621OVSEh0NirGgjPuApsQ
S1OMWqmO4qmuYHrHMAXpc8yGaSpun3Pg7xPuTYb39kpiBGmX1XQYjmXg9qLwfI9B
vR0UvajHKMWslUeMy5iC4necoQ0OEzSXLRHlosS2N4Zheofg07Uw9witPFXVIaq2
aMI3ii6t0bdrI2zZq5OmuoaDhHjyzt7tHw7oBCvSqCr65/dunnv2P4uaO05LupXY
6FZEqS4baT2CjmQ2hhhZzMAnkl0JFEszrfO0cCrvQgXog+VdnvOfW10uYqzECrxp
BeOe88K2VIgXemvZEpuboxG8qAyQOA/SzRiSUBShnPXt/HcaAadT76EICd85WnHB
Q2qM0uFtusoz42lWIFYfpFStBhRwZcoCFV54yZ9d+gEeR2H4BB5TZGmTdCs/mOkL
RzbzONP2AreLpUg7kFkA
=2won
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
