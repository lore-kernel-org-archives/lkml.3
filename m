Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab3HDJWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:22:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3HDJWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:22:52 -0400
Date: Sun, 4 Aug 2013 17:24:09 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.89
Message-ID: <20130804092409.GA7935@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.89 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/powerpc/include/asm/module.h       |    5 -
 arch/powerpc/kernel/vmlinux.lds.S       |    3=20
 drivers/acpi/acpi_memhotplug.c          |    1=20
 drivers/ata/Kconfig                     |    2=20
 drivers/ata/sata_inic162x.c             |   14 ++
 drivers/gpu/drm/radeon/atom.c           |    5 +
 drivers/gpu/drm/radeon/radeon_combios.c |  151 +++++++++------------------=
-----
 drivers/net/virtio_net.c                |    5 -
 drivers/scsi/qla2xxx/qla_iocb.c         |   11 +-
 drivers/scsi/sd.c                       |   22 +---
 drivers/staging/comedi/comedi_fops.c    |    7 +
 drivers/usb/core/hub.c                  |    9 +
 drivers/usb/host/xhci-ring.c            |    2=20
 drivers/usb/host/xhci.c                 |    6 -
 drivers/usb/misc/sisusbvga/sisusb.c     |    1=20
 drivers/usb/serial/ftdi_sio.c           |   31 +++++-
 drivers/usb/serial/ftdi_sio_ids.h       |   34 ++++++-
 drivers/usb/serial/ti_usb_3410_5052.c   |    2=20
 drivers/usb/storage/unusual_devs.h      |   14 ++
 drivers/virtio/virtio_ring.c            |   59 ++++++++++--
 drivers/xen/evtchn.c                    |   21 ----
 fs/super.c                              |   25 ++---
 include/linux/virtio.h                  |    4=20
 kernel/trace/trace_syscalls.c           |    3=20
 mm/page_alloc.c                         |    4=20
 sound/soc/codecs/max98088.c             |    2=20
 27 files changed, 255 insertions(+), 190 deletions(-)

Al Viro (1):
      livelock avoidance in sget()

Alex Deucher (2):
      drm/radeon: improve dac adjust heuristics for legacy pdac
      drm/radeon/atom: initialize more atom interpretor elements to 0

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.

David Vrabel (1):
      xen/evtchn: avoid a deadlock when unbinding an event channel

Ewan D. Milne (1):
      SCSI: sd: fix crash when UA received on DIF enabled device

Greg Kroah-Hartman (1):
      Linux 3.0.89

Ian Abbott (1):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write

Johan Hovold (1):
      USB: ti_usb_3410_5052: fix dynamic-id matching

J=F3hann B. Gu=F0mundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards

Michael S. Tsirkin (2):
      virtio: support unlocked queue poll
      virtio_net: fix race in RX VQ processing

Oleksij Rempel (1):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings

Ren Bigcren (2):
      USB: storage: Add MicroVault Flash Drive to unusual_devs
      USB: storage: Add MicroVault Flash Drive to unusual_devs

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.

Saurav Kashyap (1):
      SCSI: qla2xxx: Properly set the tagging for commands.

Tejun Heo (1):
      libata: make it clear that sata_inic162x is experimental

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path

Wanpeng Li (1):
      mm/memory-hotplug: fix lowmem count overflow when offline pages

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.

zhangwei(Jovi) (1):
      tracing: Fix irqs-off tag display in syscall tracing


--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR/h25AAoJEDjbvchgkmk+gGcP/048vvPmKeHGfXIBiyPmM9DU
gUxRzFms1IpRCUL4ZIm/1wdmjjoHqEZOqLA9rr6R/lbkeOKgUzDiqkojoUo5WS78
kbxHc1DKIYe/qfyms/zTqieub5Y0eTq/enHPzlFUiBi1JYScQDwjpW/bv7vdWjM9
ueCoEZ23XrLArCN5qKIXYePyNGjd4jBtE8Y2nuV8MPZzMLVcyXZLnMF81CP7dWf/
2+QLDZ/84RDMsrQrmKEoJ9s52AuBBHS0t5YE0zrLQa4oCRbPYQiS/0ZIe09l7fj7
sUUhWC7KNW5vjH5ILAHkpzqOfDrQU6fCjLf1DGDqGH3tmxIiXV9shTc2vHsBR10l
J9G1ATWzl8gzhWh1UJY/7xGVfCPxRiAh/SBia2JmhKI78TAd5PUig90/iTrj/bzT
BTDR77MHXE5VOu/+wNHBXFjlxeR6bitoZaZ4fElSpMsC3TWFsZxKhvdTnBiINisA
bCMTMz1BkTj6KY1r/foBf3YNFtG3HOX/1APAVG1KK+BQecXAIcMlPRuyaTD/HGjl
q4JZnYhOiEt8iYUPmzejspH/VQ27H9XeLs+NWgt7fcuQPXgtvT3ii2JvhbAr4mRO
+C729VYTvCwHYCT5OSiqSjvmLkjS0oZeC44g7bV5mr9r7E8HhBk/MrFN6RMEdM5+
DDhHOeYHFR5BiC+tS+3T
=yqId
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
