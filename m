Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab3K0Bh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:37:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333Ab3K0A6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.12 000/116] 3.12.2-stable review
Date: Tue, 26 Nov 2013 16:56:13 -0800
Message-Id: <20131127005736.915454872@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.2 release.
There are 116 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 29 00:57:18 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.12.2-rc1

Mauro Carvalho Chehab <m.chehab@samsung.com>
    cris: media platform drivers: fix build

Miklos Szeredi <miklos@szeredi.hu>
    GFS2: fix dentry leaks

Miklos Szeredi <mszeredi@suse.cz>
    GFS2: d_splice_alias() can't return error

Junxiao Bi <junxiao.bi@oracle.com>
    configfs: fix race between dentry put and lookup

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/vtime: correct idle time calculation

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/time: fix get_tod_clock_ext inline assembly

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: core: properly free host / device structs in err path

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: dsps: redo the otg timer

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: dsps: move try_idle to start hook

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: call musb_start() only once in OTG mode

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: cancel work on removal

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800usb: slow down TX status polling

Thomas Pugliese <thomas.pugliese@gmail.com>
    usb: wusbcore: set the RPIPE wMaxPacketSize value correctly

Julius Werner <jwerner@chromium.org>
    usb: hub: Clear Port Reset Change during init/resume

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    usb: Disable USB 2.0 Link PM before device reset.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Set L1 device slot on USB2 LPM enable/disable.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Enable LPM support only for hardwired or BESL devices

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    usb: Don't enable USB 2.0 Link PM by default.

Tomas Winkler <tomas.winkler@intel.com>
    mei: nfc: fix memory leak in error path

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Avoid deep recursion in rpc_release_client

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Fix a data corruption issue when retransmitting RPC calls

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: gss_alloc_msg - choose _either_ a v0 message or a v1 message

Christoph Lameter <cl@linux.com>
    slub: Handle NULL parameter in kmem_cache_flags

Anton Blanchard <anton@samba.org>
    powerpc/pseries: Duplicate dtl entries sometimes sent to userspace

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/eeh: Enable PCI_COMMAND_MASTER for PCI bridges

Michael Neuling <mikey@neuling.org>
    powerpc/signals: Mark VSX not saved with small contexts

Heiko Carstens <heiko.carstens@de.ibm.com>
    powerpc: Fix __get_user_pages_fast() irq handling

Anton Blanchard <anton@samba.org>
    powerpc: ppc64 address space capped at 32TB, mmap randomisation disabled

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/powernv: Add PE to its own PELTV

Prarit Bhargava <prarit@redhat.com>
    powerpc/vio: use strcpy in modalias_show

Gerhard Sittig <gsi@denx.de>
    powerpc/mpc512x: silence build warning upon disabled DIU

Anatolij Gustschin <agust@denx.de>
    powerpc/52xx: fix build breakage for MPC5200 LPBFIFO module

Mike Snitzer <snitzer@redhat.com>
    block: properly stack underlying max_segment_size to DM device

Mikulas Patocka <mpatocka@redhat.com>
    block: fix a probe argument to blk_register_region

Jeff Moyer <jmoyer@redhat.com>
    block: fix race between request completion and timeout handling

Roger Tseng <rogerable@realtek.com>
    drivers/memstick/core/ms_block.c: fix unreachable state in h_msb_read_page()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Fix max6696 alarm handling

Christoffer Dall <christoffer.dall@linaro.org>
    arm/arm64: KVM: Fix hyp mappings of vmalloc regions

Greg Edwards <gedwards@ddn.com>
    KVM: IOMMU: hva align mapping page size

Kevin Hao <haokexin@gmail.com>
    ftrace/x86: skip over the breakpoint for ftrace caller

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix emulation of "movzbl %bpl, %eax"

Thomas Renninger <trenn@suse.de>
    x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error

Fenghua Yu <fenghua.yu@intel.com>
    x86/apic: Disable I/O APIC before shutdown of the local APIC

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix xdr decoding of large non-write compounds

Christoph Hellwig <hch@infradead.org>
    nfsd: make sure to balance get/put_write_access

Christoph Hellwig <hch@infradead.org>
    nfsd: split up nfsd_setattr

Jeff Layton <jlayton@redhat.com>
    nfs: don't retry detect_trunking with RPC_AUTH_UNIX more than once

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix discarded security labels on setattr

J. Bruce Fields <bfields@redhat.com>
    nfsd: return better errors to exportfs

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Fix a missing initialisation when reading the SELinux label

Jeff Layton <jlayton@redhat.com>
    nfs: fix oops when trying to set SELinux label

Jeff Layton <jlayton@redhat.com>
    nfs: fix inverted test for delegation in nfs4_reclaim_open_state

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix state reference counting in _nfs4_opendata_reclaim_to_nfs4_state

Weston Andros Adamson <dros@netapp.com>
    NFSv4: don't reprocess cached open CLAIM_PREVIOUS

Weston Andros Adamson <dros@netapp.com>
    NFSv4: don't fail on missing fattr in open recover

Weston Andros Adamson <dros@netapp.com>
    NFSv4: fix NULL dereference in open recover

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.2: Fix a mismatch between Linux labeled NFS and the NFSv4.2 spec

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Provide missing pin configs for VAIO with ALC260

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add headset quirk for Dell Inspiron 3135

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix the headphone jack detection on Sony VAIO TX

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix unbalanced runtime PM notification at resume

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't clear the power state at snd_hda_codec_reset()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't turn off EAPD for headphone on Lenovo N100

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Check keep_eapd_on before inv_eapd

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Fix Line Out automute on Realtek multifunction jacks

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add pincfg fixup for ASUS W5A

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add support for CX20952

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Make sure mute LEDs stay on during runtime suspend (Realtek)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Force buffer alignment for Haswell HDMI controllers

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Enable SPDIF for Acer TravelMate 6293

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Introduce the bitmask for excluding output volume

Kailang Yang <kailang@realtek.com>
    ALSA: hda - Add support of ALC255 codecs

Takashi Iwai <tiwai@suse.de>
    ALSA: msnd: Avoid duplicated driver name

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Apply MacBook fixups for CS4208 correctly

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Apply GPIO setup for MacBooks with CS4208

Takashi Iwai <tiwai@suse.de>
    ALSA: pcsp: Fix the order of input device unregistration

Vinod Koul <vinod.koul@intel.com>
    ALSA: compress: fix drain calls blocking other compress functions (v6)

Vinod Koul <vinod.koul@intel.com>
    ALSA: compress: fix drain calls blocking other compress functions

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Fix probe of multiple cards

Kees Cook <keescook@chromium.org>
    exec/ptrace: fix get_dumpable() incorrect tests

Mimi Zohar <zohar@linux.vnet.ibm.com>
    Revert "ima: policy for RAMFS"

Hans de Goede <hdegoede@redhat.com>
    Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops"

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: fix HT TX descriptor settings regression

Gabor Juhos <juhosg@openwrt.org>
    rt2x00: rt2800lib: fix VGC adjustment for RT5592

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: check if device is still available on rt2x00mac_flush()

Felix Fietkau <nbd@openwrt.org>
    rt2x00: fix a crash bug in the HT descriptor handling fix

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Fix a bug in channel rescind code

Kees Cook <keescook@chromium.org>
    lkdtm: isolate stack corruption test

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: avoid memleak for subdevice private

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8188eu: Set device type to wlan

Rashika Kheria <rashika.kheria@gmail.com>
    Staging: zram: Fix access of NULL pointer

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / hotplug: Do not execute "insert in progress" _OST

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / hotplug: Fix handle_root_bridge_removal()

Aaron Lu <aaron.lu@intel.com>
    ACPI / video: Quirk initial backlight level 0

Puneet Kumar <puneetster@chromium.org>
    ACPI / EC: Ensure lock is acquired before accessing ec struct members

Steven Rostedt <rostedt@goodmis.org>
    perf/ftrace: Fix paranoid level for enabling function tracer

Peter Zijlstra <peterz@infradead.org>
    sched, idle: Fix the idle polling state logic

Suman Anna <s-anna@ti.com>
    ARM: OMAP2+: hwmod: check for module address space during init

Takashi Iwai <tiwai@suse.de>
    thinkpad_acpi: Fix build error when CONFIG_SND_MAX_CARDS > 32

Ben Skeggs <bskeggs@redhat.com>
    drm/nvc0-/gr: fix a number of missing explicit array terminators...

John Stultz <john.stultz@linaro.org>
    staging: ashmem: Fix ASHMEM_PURGE_ALL_CACHES return value

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm: shmobile: Add dependency on BACKLIGHT_CLASS_DEVICE

Greg Thelen <gthelen@google.com>
    ipc,shm: fix shm_file deletion races

Jesper Nilsson <jesper.nilsson@axis.com>
    ipc,shm: correct error return value in shmctl (SHM_UNLOCK)

hahnjo <hahnjo@hahnjo.de>
    alx: Reset phy speed after resume

Markus Pargmann <mpa@pengutronix.de>
    can: c_can: Fix RX message handling, handle lost message before EOB

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: s390 - Fix aes-cbc IV corruption

Neil Horman <nhorman@tuxdriver.com>
    crypto: ansi_cprng - Fix off by one error in non-block size request

Josef Bacik <jbacik@fusionio.com>
    Btrfs: relocate csums properly with prealloc extents

Olivier Sobrie <olivier@sobrie.be>
    can: kvaser_usb: fix usb endpoints detection

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix tiocmget error handling

Eric Sandeen <sandeen@sandeen.net>
    xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields

Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
    aacraid: prevent invalid pointer dereference

Dan Carpenter <dan.carpenter@oracle.com>
    libertas: potential oops in debugfs

Al Viro <viro@zeniv.linux.org.uk>
    prepend_path() needs to reinitialize dentry/vfsmount/mnt on restarts


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/kvm/mmu.c                                 |  34 +++-
 arch/arm/mach-omap2/omap_hwmod.c                   |  29 ++--
 arch/cris/include/asm/io.h                         |   1 +
 arch/ia64/include/asm/processor.h                  |   2 +-
 arch/powerpc/kernel/eeh.c                          |   9 ++
 arch/powerpc/kernel/signal_32.c                    |  10 +-
 arch/powerpc/kernel/time.c                         |   4 +-
 arch/powerpc/kernel/vio.c                          |   4 +-
 arch/powerpc/mm/gup.c                              |   5 +-
 arch/powerpc/mm/slice.c                            |   2 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c       |   3 +
 arch/powerpc/platforms/52xx/Kconfig                |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  12 +-
 arch/s390/crypto/aes_s390.c                        |  19 ++-
 arch/s390/include/asm/timex.h                      |   6 +-
 arch/s390/kernel/smp.c                             |   4 +-
 arch/s390/kernel/vtime.c                           |   2 +-
 arch/x86/kernel/crash.c                            |   2 +-
 arch/x86/kernel/ftrace.c                           |  14 +-
 arch/x86/kernel/microcode_amd.c                    |   2 +-
 arch/x86/kernel/process.c                          |   6 +-
 arch/x86/kernel/reboot.c                           |   8 +-
 arch/x86/kvm/emulate.c                             |   5 +-
 block/blk-core.c                                   |   1 +
 block/blk-settings.c                               |   1 +
 block/blk-timeout.c                                |   3 +-
 crypto/ansi_cprng.c                                |   4 +-
 drivers/acpi/ec.c                                  |   3 +-
 drivers/acpi/pci_root.c                            |   5 +-
 drivers/acpi/processor_idle.c                      |  46 ++----
 drivers/acpi/scan.c                                |   2 -
 drivers/acpi/video.c                               |   2 +-
 drivers/block/brd.c                                |   2 +-
 drivers/block/loop.c                               |   2 +-
 drivers/bluetooth/btusb.c                          |   1 -
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc1.c    |   4 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd7.c    |   1 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd9.c    |   1 +
 drivers/gpu/drm/shmobile/Kconfig                   |   1 +
 drivers/hv/channel_mgmt.c                          |   5 +-
 drivers/hwmon/lm90.c                               |  11 +-
 drivers/idle/intel_idle.c                          |   2 +-
 drivers/memstick/core/ms_block.c                   |   2 +-
 drivers/misc/lkdtm.c                               |  16 +-
 drivers/misc/mei/nfc.c                             |  10 +-
 drivers/net/can/c_can/c_can.c                      |   6 +-
 drivers/net/can/usb/kvaser_usb.c                   |  20 ++-
 drivers/net/ethernet/atheros/alx/main.c            |   3 +
 drivers/net/wireless/libertas/debugfs.c            |   6 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  11 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |  12 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   3 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   7 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   4 +-
 drivers/platform/x86/thinkpad_acpi.c               |   7 +-
 drivers/scsi/aacraid/commctrl.c                    |   3 +-
 drivers/staging/android/ashmem.c                   |   2 +-
 drivers/staging/comedi/comedi_fops.c               |   5 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |   5 +
 drivers/staging/zram/zram_drv.c                    |   6 +-
 drivers/usb/core/driver.c                          |   3 +
 drivers/usb/core/hub.c                             |  39 +++++
 drivers/usb/core/sysfs.c                           |   6 +-
 drivers/usb/host/xhci-mem.c                        |  10 --
 drivers/usb/host/xhci.c                            | 165 +++-----------------
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/musb/musb_core.c                       |   4 +
 drivers/usb/musb/musb_dsps.c                       |  25 +--
 drivers/usb/musb/musb_virthub.c                    |  19 ++-
 drivers/usb/serial/mos7840.c                       |   4 +
 drivers/usb/wusbcore/wa-rpipe.c                    |   5 +-
 fs/btrfs/relocation.c                              |  18 ++-
 fs/configfs/dir.c                                  |  16 +-
 fs/dcache.c                                        |   9 +-
 fs/exec.c                                          |   6 +
 fs/gfs2/inode.c                                    |  30 ++--
 fs/nfs/nfs4proc.c                                  |  36 ++---
 fs/nfs/nfs4state.c                                 |   9 +-
 fs/nfsd/export.c                                   |  15 +-
 fs/nfsd/nfs4xdr.c                                  |   4 +-
 fs/nfsd/vfs.c                                      | 173 ++++++++++++---------
 fs/xfs/xfs_sb.c                                    |  13 +-
 include/linux/binfmts.h                            |   3 -
 include/linux/nfs4.h                               |   2 +-
 include/linux/sched.h                              |  82 +++++++++-
 include/linux/thread_info.h                        |   2 +
 include/linux/usb.h                                |   4 +-
 include/sound/compress_driver.h                    |   9 ++
 ipc/shm.c                                          |  37 ++++-
 kernel/cpu/idle.c                                  |   9 +-
 kernel/ptrace.c                                    |   3 +-
 kernel/trace/trace_event_perf.c                    |   2 +-
 mm/slub.c                                          |   4 +-
 net/sunrpc/auth_gss/auth_gss.c                     |   1 +
 net/sunrpc/clnt.c                                  |  29 ++--
 net/sunrpc/xprtsock.c                              |  28 +++-
 security/integrity/ima/ima_policy.c                |   1 -
 sound/core/compress_offload.c                      |  54 ++++++-
 sound/drivers/pcsp/pcsp.c                          |   2 +-
 sound/isa/msnd/msnd_pinnacle.c                     |   4 +-
 sound/pci/hda/hda_codec.c                          |   7 +-
 sound/pci/hda/hda_generic.c                        |  12 +-
 sound/pci/hda/hda_generic.h                        |   3 +
 sound/pci/hda/hda_intel.c                          |  14 +-
 sound/pci/hda/patch_analog.c                       |   6 +-
 sound/pci/hda/patch_cirrus.c                       |  28 +++-
 sound/pci/hda/patch_conexant.c                     |   3 +
 sound/pci/hda/patch_realtek.c                      |  83 +++++++++-
 sound/usb/6fire/chip.c                             |   2 +-
 virt/kvm/iommu.c                                   |   4 +
 112 files changed, 945 insertions(+), 519 deletions(-)


