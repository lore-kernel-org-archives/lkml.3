Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3HDJkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:40:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3HDJkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:40:21 -0400
Date: Sun, 4 Aug 2013 17:38:32 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.5
Message-ID: <20130804093832.GA8368@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.5 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/arm/boot/compressed/atags_to_fdt.c      |   44 +++
 arch/powerpc/include/asm/module.h            |    5=20
 arch/powerpc/kernel/vmlinux.lds.S            |    3=20
 arch/x86/kernel/acpi/sleep.c                 |   18 +
 arch/x86/kernel/cpu/mtrr/generic.c           |   21 -
 arch/x86/kernel/cpu/mtrr/main.c              |   16 -
 arch/x86/kernel/head_64.S                    |    2=20
 drivers/acpi/acpi_memhotplug.c               |    1=20
 drivers/acpi/scan.c                          |   13 -
 drivers/acpi/video.c                         |    8=20
 drivers/ata/Kconfig                          |    2=20
 drivers/ata/ata_piix.c                       |    2=20
 drivers/ata/sata_inic162x.c                  |   14 +
 drivers/base/regmap/regmap.c                 |    2=20
 drivers/block/xen-blkback/blkback.c          |   13 +
 drivers/cpufreq/intel_pstate.c               |   12 -
 drivers/crypto/caam/caamhash.c               |    2=20
 drivers/firewire/core-cdev.c                 |    3=20
 drivers/firewire/ohci.c                      |   10=20
 drivers/gpu/drm/i915/i915_dma.c              |   17 -
 drivers/gpu/drm/i915/i915_drv.c              |   13 -
 drivers/gpu/drm/i915/i915_drv.h              |    4=20
 drivers/gpu/drm/i915/i915_gem.c              |   54 +++-
 drivers/gpu/drm/i915/intel_display.c         |   39 ++-
 drivers/gpu/drm/i915/intel_panel.c           |    3=20
 drivers/gpu/drm/i915/intel_pm.c              |   45 +++
 drivers/gpu/drm/i915/intel_ringbuffer.c      |    9=20
 drivers/gpu/drm/nouveau/nv17_fence.c         |    2=20
 drivers/gpu/drm/nouveau/nv50_fence.c         |   14 -
 drivers/gpu/drm/radeon/atom.c                |    5=20
 drivers/gpu/drm/radeon/atombios_dp.c         |   43 +++
 drivers/gpu/drm/radeon/evergreen_hdmi.c      |    8=20
 drivers/gpu/drm/radeon/r600.c                |    2=20
 drivers/gpu/drm/radeon/r600_hdmi.c           |    6=20
 drivers/gpu/drm/radeon/radeon.h              |    1=20
 drivers/gpu/drm/radeon/radeon_combios.c      |  159 ++++---------
 drivers/gpu/drm/radeon/radeon_gart.c         |    1=20
 drivers/gpu/drm/radeon/radeon_irq_kms.c      |    9=20
 drivers/gpu/drm/radeon/radeon_object.h       |    2=20
 drivers/gpu/drm/radeon/radeon_ring.c         |    1=20
 drivers/gpu/drm/radeon/radeon_sa.c           |    7=20
 drivers/hv/hv_balloon.c                      |   21 +
 drivers/infiniband/ulp/isert/ib_isert.c      |  119 +++++++---
 drivers/infiniband/ulp/isert/ib_isert.h      |    1=20
 drivers/md/dm-ioctl.c                        |    3=20
 drivers/md/dm-mpath.c                        |    8=20
 drivers/md/dm-verity.c                       |    5=20
 drivers/md/dm.c                              |    9=20
 drivers/md/md.c                              |   14 -
 drivers/md/raid1.c                           |   53 ++--
 drivers/md/raid10.c                          |    8=20
 drivers/md/raid5.c                           |   15 -
 drivers/md/raid5.h                           |    1=20
 drivers/net/wireless/rtlwifi/pci.c           |   13 -
 drivers/net/wireless/rtlwifi/ps.c            |   12 +
 drivers/net/wireless/rtlwifi/ps.h            |    1=20
 drivers/net/wireless/rtlwifi/usb.c           |    2=20
 drivers/net/xen-netfront.c                   |   31 +-
 drivers/scsi/isci/task.c                     |    9=20
 drivers/scsi/qla2xxx/qla_iocb.c              |   11=20
 drivers/scsi/sd.c                            |   22 -
 drivers/staging/android/logger.c             |    4=20
 drivers/staging/comedi/comedi_fops.c         |   32 +-
 drivers/target/iscsi/iscsi_target.c          |  313 ++++++++++++----------=
-----
 drivers/target/iscsi/iscsi_target.h          |    2=20
 drivers/target/iscsi/iscsi_target_configfs.c |    2=20
 drivers/target/iscsi/iscsi_target_core.h     |    4=20
 drivers/target/iscsi/iscsi_target_erl0.c     |    8=20
 drivers/target/iscsi/iscsi_target_erl1.c     |   26 +-
 drivers/target/iscsi/iscsi_target_util.c     |   27 +-
 drivers/target/iscsi/iscsi_target_util.h     |    3=20
 drivers/tty/tty_port.c                       |    5=20
 drivers/usb/core/hub.c                       |   48 +++-
 drivers/usb/core/hub.h                       |    3=20
 drivers/usb/dwc3/core.c                      |    2=20
 drivers/usb/dwc3/core.h                      |    4=20
 drivers/usb/dwc3/gadget.c                    |    1=20
 drivers/usb/gadget/udc-core.c                |    2=20
 drivers/usb/host/ehci-hub.c                  |    1=20
 drivers/usb/host/xhci-pci.c                  |    1=20
 drivers/usb/host/xhci-ring.c                 |    2=20
 drivers/usb/host/xhci.c                      |   13 -
 drivers/usb/misc/sisusbvga/sisusb.c          |    1=20
 drivers/usb/serial/ftdi_sio.c                |   31 ++
 drivers/usb/serial/ftdi_sio_ids.h            |   34 ++
 drivers/usb/serial/mos7840.c                 |   25 +-
 drivers/usb/serial/ti_usb_3410_5052.c        |    2=20
 drivers/usb/storage/unusual_devs.h           |    7=20
 drivers/xen/evtchn.c                         |   21 -
 fs/btrfs/extent-tree.c                       |   13 +
 fs/btrfs/scrub.c                             |    2=20
 fs/nfsd/vfs.c                                |    5=20
 fs/super.c                                   |   25 --
 include/linux/firewire.h                     |    1=20
 include/target/iscsi/iscsi_transport.h       |    9=20
 include/uapi/linux/firewire-cdev.h           |    4=20
 kernel/trace/trace.c                         |   33 +-
 kernel/trace/trace_events.c                  |   21 +
 mm/memory.c                                  |    9=20
 mm/mempolicy.c                               |    6=20
 mm/mmap.c                                    |    2=20
 net/sunrpc/xprtrdma/svc_rdma_marshal.c       |   20 +
 sound/pci/hda/patch_realtek.c                |    3=20
 sound/soc/codecs/max98088.c                  |    2=20
 sound/soc/codecs/sgtl5000.c                  |    2=20
 sound/soc/codecs/wm8962.c                    |   24 +-
 sound/soc/tegra/tegra20_ac97.c               |    6=20
 sound/soc/tegra/tegra20_spdif.c              |    4=20
 tools/hv/hv_kvp_daemon.c                     |    5=20
 tools/perf/config/utilities.mak              |    2=20
 111 files changed, 1120 insertions(+), 697 deletions(-)

Al Viro (1):
      livelock avoidance in sget()

Alan Stern (1):
      USB: global suspend and remote wakeup don't mix

Alex Deucher (6):
      drm/radeon/hdmi: make sure we have an afmt block assigned
      drm/radeon: allow selection of alignment in the sub-allocator
      drm/radeon: fix endian issues with DP handling (v3)
      drm/radeon: improve dac adjust heuristics for legacy pdac
      drm/radeon: fix audio dto programming on DCE4+
      drm/radeon/atom: initialize more atom interpretor elements to 0

Alexander Z Lam (2):
      tracing: Fix error handling to ensure instances can always be removed
      tracing: Miscellaneous fixes for trace_array ref counting

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues

Ben Widawsky (1):
      drm/i915: fix missed hunk after GT access breakage

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.

Chris Wilson (4):
      drm/i915: Fix write-read race with multiple rings
      drm/i915: Fix incoherence with fence updates on Sandybridge+
      drm/i915: Fix dereferencing invalid connectors in is_crtc_connector_o=
ff()
      drm/i915: Serialize almost all register access

Christian K=F6nig (1):
      drm/radeon: fix UVD fence emit

Clemens Ladisch (1):
      firewire: fix libdc1394/FlyCap2 iso event regression

Dan Carpenter (1):
      svcrdma: underflow issue in decode_write_list()

Daniel Mack (1):
      regmap: cache: bail in regmap_async_complete() for bus-less maps

Daniel Vetter (3):
      drm/i915: fix up ring cleanup for the i830/i845 CS tlb w/a
      drm/i915: correctly restore fences with objects attached
      drm/i915: fix up gt init sequence fallout

David Henningsson (2):
      ALSA: hda - Yet another Dell headset mic quirk
      ALSA: hda - Guess what, it's two more Dell headset mic quirks

David Vrabel (1):
      xen/evtchn: avoid a deadlock when unbinding an event channel

Dirk Brandewie (1):
      cpufreq / intel_pstate: Change to scale off of max P-state

Ewan D. Milne (1):
      SCSI: sd: fix crash when UA received on DIF enabled device

Fabio Estevam (1):
      ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers wit=
h xhci 1.0

Gianluca Anzolin (1):
      tty_port: Fix refcounting leak in tty_port_tty_hangup()

Greg Kroah-Hartman (1):
      Linux 3.10.5

Gregory CLEMENT (1):
      ARM: 7722/1: zImage: Convert 32bits memory size and address from ATAG=
 to 64bits DTB

Guenter Roeck (1):
      Partially revert "drm/i915: unconditionally use mt forcewake on hsw/i=
vb"

H. Peter Anvin (1):
      x86, suspend: Handle CPUs which fail to #GP on RDMSR

Hannes Reinecke (1):
      dm mpath: fix ioctl deadlock when no paths

Harshula Jayasuriya (1):
      nfsd: nfsd_open: when dentry_open returns an error do not propagate a=
s struct file

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type

Ian Abbott (2):
      staging: comedi: fix a race between do_cmd_ioctl() and read/write
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write

Jan Beulich (1):
      xen-netfront: pull on receive skb may need to happen earlier

Jeff Skirvin (1):
      SCSI: isci: Fix a race condition in the SSP task management path

Joern Engel (1):
      iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow

Johan Hovold (2):
      USB: mos7840: fix memory leak in open
      USB: ti_usb_3410_5052: fix dynamic-id matching

Josef Bacik (2):
      Btrfs: fix lock leak when resuming snapshot deletion
      Btrfs: re-add root to dead root list if we stop dropping it

J=F3hann B. Gu=F0mundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

K. Y. Srinivasan (3):
      Tools: hv: KVP: Fix a bug in IPV6 subnet enumeration
      Drivers: hv: balloon: Fix a bug in the hot-add code
      Drivers: hv: balloon: Do not post pressure status if interrupted

Kamal Mostafa (1):
      drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight

Karlis Ogsts (1):
      staging: android: logger: Correct write offset reset on error

Kees Cook (1):
      x86: make sure IDT is page aligned

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check device permissions before allowing OP_DISCARD

Konstantin Khlebnikov (1):
      drm/i915: fix long-standing SNB regression in power consumption after=
 resume v2

Lan Tianyu (1):
      ACPI / video: ignore BIOS initial backlight value for Fujitsu E753

Larry Finger (1):
      rtlwifi: Initialize power-setting callback for USB devices

Maarten Lankhorst (1):
      drm/nouveau: fix semaphore dmabuf obj

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards

Michael Witten (1):
      perf tools: Revert regression in configuration of Python support

Mikulas Patocka (2):
      dm ioctl: set noio flag to avoid __vmalloc deadlock
      dm verity: fix inability to use a few specific devices sizes

NeilBrown (4):
      md: Remove recent change which allows devices to skip recovery.
      md/raid1: fix bio handling problems in process_checks()
      md/raid5: fix interaction of 'replace' and 'recovery'.
      md/raid10: remove use-after-free bug.

Nicholas Bellinger (5):
      iser-target: Fix isert_put_reject payload buffer post
      iser-target: Fix session reset bug with RDMA_CM_EVENT_DISCONNECTED
      iscsi-target: Fix ISCSI_OP_SCSI_TMFUNC handling for iser
      iscsi-target: Fix iscsit_add_reject* usage for iser
      iscsi-target: Fix iscsit_sequence_cmd reject handling for iser

Nicolin Chen (1):
      ASoC: wm8962: Remove remaining direct register cache accesses

Oleg Nesterov (2):
      tracing: Kill the unbalanced tr->ref++ in tracing_buffers_open()
      mm: mempolicy: fix mbind_range() && vma_adjust() interaction

Oleksij Rempel (1):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings

Ondrej Zary (1):
      drm/radeon: Another card with wrong primary dac adj

Rafael J. Wysocki (2):
      ACPI / scan: Always call acpi_bus_scan() for bus check notifications
      ACPI / scan: Do not try to attach scan handlers to devices having them

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs

Richard Zhao (1):
      ASoC: tegra: correct playback_dma_data setup

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices

Roger Quadros (1):
      USB: EHCI: Fix resume signalling on remote wakeup

Rong Wang (1):
      usb: gadget: udc-core: fix the typo of udc state attribute

Ruchika Kharwar (1):
      usb: dwc3: fix the error returned with usb3_phy failure

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.

Saurav Kashyap (1):
      SCSI: qla2xxx: Properly set the tagging for commands.

Sergey Senozhatsky (1):
      radeon kms: do not flush uninitialized hotplug work

Stefan Behrens (1):
      Btrfs: fix wrong write offset when replacing a device

Steven Rostedt (Red Hat) (1):
      tracing: Remove locking trace_types_lock from tracing_reset_all_onlin=
e_cpus()

Tejun Heo (1):
      libata: make it clear that sata_inic162x is experimental

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path

Vakul Garg (1):
      crypto: caam - Fixed the memory out of bound overwrite issue

Vineet Gupta (1):
      mm: fix the TLB range flushed when __tlb_remove_page() runs out of sl=
ots

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.

Xiong Zhang (1):
      drm/i915: Correct obj->mm_list link to dev_priv->dev_priv->mm.inactiv=
e_list

Yinghai Lu (1):
      x86: Fix /proc/mtrr with base/size more than 44bits

Youquan Song (1):
      ata: Fix DVD not dectected at some platform with Wellsburg PCH


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR/iEYAAoJEDjbvchgkmk+BeYP/A5Lwji4lKFlIv4KUAXiR8VX
wnajRl/QmQnO7j9De/CJvcQN7fi2TG44Fpg/uLjtWD1OFOFnd5XB0LVa6gL4ttVO
r8BOGAAlBJ23YiZ22kRu89RJbmu8BEO8p9lgfVlkTkc0LJUXU3TASXm5B3fJzrOd
QLYpmSbqRHs2PjHK1EGdfostd92jfyE64vaAH+b49uIU/wpRoYMwlb53SXrYA30o
87tIdGPBKV8EnVw2LbCcmJIZMD6NJLmk9dRernSG2H5cg8rwxXyGUKtfeFzYn/ww
VsdvS8v7o7BS4KzAgSfp86pCEHwPeVKa2UXLOrLWARU6B7LacYp6ISNkuqV6YLC8
w4cZUQytreQ7uLQFtmaVjdw1o+OnfuulGsE9NvoB3eJzyG6WphwZb40Zp7elrdi8
y+vr13rTvLiEeuda+dLk/gn7gGYZn7sTt09P+GVp8pBatz1jbilluOiyK+MOa51i
sTmBceWIh2NaAKrFIMHemlGhRuOqiYG69l4e6yzjtEifo5Hw1Y3fIOchGWnluIIw
ZWHotVUwo2CTVsB+Ij4A1x+/dYvBOgxcqF4u16dfMGAhw7aRu3QgDuX9PGo5lTif
zrl8xEchfBY9yF4sSnT5x5Ap8bXjTUyS5yWRR4UMqubKfp4ntatGJ9PN0LAw03c8
KAXXR0EaDzR8vCnnqBJE
=CTms
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
