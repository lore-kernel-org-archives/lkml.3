Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3HDJh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:37:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3HDJh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:37:56 -0400
Date: Sun, 4 Aug 2013 17:38:01 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.56
Message-ID: <20130804093801.GA8326@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.56 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/powerpc/include/asm/module.h            |    5=20
 arch/powerpc/kernel/vmlinux.lds.S            |    3=20
 arch/s390/include/asm/pgtable.h              |    4=20
 drivers/acpi/acpi_memhotplug.c               |    1=20
 drivers/ata/Kconfig                          |    2=20
 drivers/ata/ata_piix.c                       |    2=20
 drivers/ata/sata_inic162x.c                  |   14 ++
 drivers/block/xen-blkback/blkback.c          |   13 ++
 drivers/firewire/core-cdev.c                 |    3=20
 drivers/firewire/ohci.c                      |   10 +
 drivers/gpu/drm/radeon/atom.c                |    5=20
 drivers/gpu/drm/radeon/atombios_dp.c         |   43 ++++++-
 drivers/gpu/drm/radeon/radeon_combios.c      |  151 ++++++++--------------=
-----
 drivers/md/dm-verity.c                       |    5=20
 drivers/md/raid10.c                          |    8 +
 drivers/md/raid5.c                           |   15 +-
 drivers/md/raid5.h                           |    1=20
 drivers/net/virtio_net.c                     |    5=20
 drivers/s390/scsi/zfcp_aux.c                 |    5=20
 drivers/s390/scsi/zfcp_fsf.c                 |   23 ++--
 drivers/scsi/qla2xxx/qla_iocb.c              |   11 +
 drivers/scsi/sd.c                            |   22 +--
 drivers/staging/comedi/comedi_fops.c         |    7 +
 drivers/target/iscsi/iscsi_target_configfs.c |    2=20
 drivers/usb/core/hub.c                       |    9 +
 drivers/usb/dwc3/core.h                      |    4=20
 drivers/usb/dwc3/gadget.c                    |    1=20
 drivers/usb/host/xhci-pci.c                  |    1=20
 drivers/usb/host/xhci-ring.c                 |    2=20
 drivers/usb/host/xhci.c                      |   13 +-
 drivers/usb/misc/sisusbvga/sisusb.c          |    1=20
 drivers/usb/serial/ftdi_sio.c                |   31 +++++
 drivers/usb/serial/ftdi_sio_ids.h            |   34 +++++-
 drivers/usb/serial/ti_usb_3410_5052.c        |    2=20
 drivers/usb/storage/unusual_devs.h           |    7 +
 drivers/virtio/virtio_ring.c                 |   54 +++++++--
 drivers/xen/evtchn.c                         |   21 ---
 fs/btrfs/extent-tree.c                       |   13 ++
 fs/super.c                                   |   25 +---
 include/linux/firewire-cdev.h                |    4=20
 include/linux/firewire.h                     |    1=20
 include/linux/virtio.h                       |    4=20
 kernel/trace/trace_syscalls.c                |    3=20
 mm/page_alloc.c                              |    4=20
 sound/soc/codecs/max98088.c                  |    2=20
 sound/soc/codecs/wm8962.c                    |   24 ++--
 47 files changed, 387 insertions(+), 235 deletions(-)

Al Viro (1):
      livelock avoidance in sget()

Alex Deucher (3):
      drm/radeon: fix endian issues with DP handling (v3)
      drm/radeon: improve dac adjust heuristics for legacy pdac
      drm/radeon/atom: initialize more atom interpretor elements to 0

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.

Clemens Ladisch (1):
      firewire: fix libdc1394/FlyCap2 iso event regression

David Vrabel (1):
      xen/evtchn: avoid a deadlock when unbinding an event channel

Ewan D. Milne (1):
      SCSI: sd: fix crash when UA received on DIF enabled device

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers wit=
h xhci 1.0

Greg Kroah-Hartman (1):
      Linux 3.4.56

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type

Ian Abbott (1):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write

Joern Engel (1):
      iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow

Johan Hovold (1):
      USB: ti_usb_3410_5052: fix dynamic-id matching

Josef Bacik (2):
      Btrfs: fix lock leak when resuming snapshot deletion
      Btrfs: re-add root to dead root list if we stop dropping it

J=F3hann B. Gu=F0mundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check device permissions before allowing OP_DISCARD

Linus Torvalds (1):
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards

Michael S. Tsirkin (2):
      virtio: support unlocked queue poll
      virtio_net: fix race in RX VQ processing

Mikulas Patocka (1):
      dm verity: fix inability to use a few specific devices sizes

NeilBrown (2):
      md/raid5: fix interaction of 'replace' and 'recovery'.
      md/raid10: remove use-after-free bug.

Nicolin Chen (1):
      ASoC: wm8962: Remove remaining direct register cache accesses

Oleksij Rempel (1):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.

Saurav Kashyap (1):
      SCSI: qla2xxx: Properly set the tagging for commands.

Steffen Maier (1):
      zfcp: status read buffers on first adapter open with link down

Tejun Heo (1):
      libata: make it clear that sata_inic162x is experimental

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path

Wanpeng Li (1):
      mm/memory-hotplug: fix lowmem count overflow when offline pages

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.

Youquan Song (1):
      ata: Fix DVD not dectected at some platform with Wellsburg PCH

zhangwei(Jovi) (1):
      tracing: Fix irqs-off tag display in syscall tracing


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR/iD5AAoJEDjbvchgkmk+hWAP/RTSew3tawqDMB1yqgS4Ok2B
J6ZAYlJOcgYgvgAr2NjIXdyf0e6vWWxxtEz0VzfoqcFelTqPnjh8Tf4/oNjo0K7c
k6JDLgaQIXC7knE4mj/pUTOJuD2EqsCt2h6LX6nE9X62t2y5oEgR7LQ0TAST67YB
CCnF8kABCFKz+VG9r6oeEWMzcbEcP00u31GOdaw9e6tTGB75+GKo9mUFpklsP5lt
qzwrfzWSE23t6PKsr9H1J4V3RSQ3mpI0nc2peCytVmNsy6S6+tkfOzJ9E+BiV+NU
dvwTAjGx3vNKNFgTNRJV/3phtmPmK9TrXaYsmXUyYFS8IlFNLmfnRoWwYjXUuaUG
4z/BKP9ttf96Hp/JwWlTMIaEnRb+At8RN2ih+xHR+ZXhJCNhsYOvMmR7GxTkB6yx
V8NUQZay9L6DJhmK6MEJjD+kgJG8sqt9wlpqd3DyuKonLtRzGMlBkD+HMKaM70Mr
P92+YyyNoxe6RYWQ/Vh/2ps/IxPPHhLcdL4XysW36hi+9Dni77s7MfWT6nAkJDLl
MKVx4D1TrxyV2wDJwCOV2IgEy/6wg7iQ3GN/e8+0HZ1AlbFMB2+75l/k5HJZWYeK
0UQLiZ+qDG20FNZNkvOIqQtHtUYk/LRbhXPMM8sUtQGklwebpuDFu3/sTjD/C4yh
RSdzJWWXwWJcfe4Xg2xP
=DeRE
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
