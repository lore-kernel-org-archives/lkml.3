Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaBVTJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 14:09:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaBVTJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 14:09:38 -0500
Date: Sat, 22 Feb 2014 11:12:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.82
Message-ID: <20140222191221.GA12420@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.82 kernel.

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

 Makefile                                |    2=20
 arch/s390/kernel/head64.S               |    7 +-
 arch/s390/mm/page-states.c              |   10 +++
 block/blk-lib.c                         |    8 ++
 drivers/block/xen-blkfront.c            |    5 +
 drivers/char/raw.c                      |    2=20
 drivers/infiniband/hw/qib/qib_iba7322.c |    5 +
 drivers/md/raid5.c                      |   90 +++++++++++++++------------=
-----
 drivers/power/max17040_battery.c        |    5 +
 drivers/spi/spi.c                       |    4 -
 drivers/staging/iio/adc/ad799x_core.c   |    3 -
 drivers/tty/n_gsm.c                     |   11 +++
 drivers/usb/serial/ftdi_sio.c           |    3 +
 drivers/usb/serial/ftdi_sio_ids.h       |    7 ++
 drivers/usb/serial/option.c             |    3 -
 drivers/usb/storage/Kconfig             |    4 +
 drivers/usb/storage/scsiglue.c          |    6 ++
 drivers/usb/storage/unusual_cypress.h   |    2=20
 drivers/usb/storage/unusual_devs.h      |    7 ++
 fs/file.c                               |    2=20
 fs/lockd/svclock.c                      |    8 ++
 kernel/irq/irqdesc.c                    |    1=20
 kernel/time/jiffies.c                   |    6 ++
 kernel/trace/ring_buffer.c              |    7 ++
 net/mac80211/tx.c                       |    2=20
 scripts/mod/file2alias.c                |    4 -
 virt/kvm/coalesced_mmio.c               |    8 --
 27 files changed, 152 insertions(+), 70 deletions(-)

Alan Stern (3):
      usb-storage: add unusual-devs entry for BlackBerry 9000
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
      usb-storage: enable multi-LUN scanning when needed

Bj=F8rn Mork (1):
      usb: ftdi_sio: add Mindstorms EV3 console adapter

Dan Carpenter (1):
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

David Vrabel (1):
      xen-blkfront: handle backend CLOSED without CLOSING

Eric W. Biederman (1):
      fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

Geert Uytterhoeven (1):
      spi: Fix crash with double message finalisation on error handling

Greg Kroah-Hartman (1):
      Linux 3.4.82

Hartmut Knaack (1):
      staging:iio:ad799x fix error_free_irq which was freeing an irq that m=
ay not have been requested

Jan Moskyto Matejka (1):
      Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

Jens Axboe (1):
      block: add cond_resched() to potentially long running ioctl discard l=
oop

Johannes Berg (1):
      mac80211: fix fragmentation code, particularly for encryption

Krzysztof Kozlowski (1):
      power: max17040: Fix NULL pointer dereference when there is no platfo=
rm_data

Lars Poeschel (1):
      tty: n_gsm: Fix for modems with brk in modem status control

Martin Schwidefsky (1):
      s390: fix kernel crash due to linkage stack instructions

Michael Holzheu (1):
      s390/dump: Fix dump memory detection

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence

Mikulas Patocka (1):
      time: Fix overflow when HZ is smaller than 60

NeilBrown (1):
      lockd: send correct lock when granting a delayed lock.

Oleg Nesterov (1):
      md/raid5: Fix CPU hotplug callback registration

Paul Bolle (1):
      raw: test against runtime value of max_raw_minors

Paul Gortmaker (1):
      genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=3Dn

Raymond Wanyoike (1):
      usb: option: blacklist ZTE MF667 net interface

Steven Rostedt (Red Hat) (1):
      ring-buffer: Fix first commit on sub-buffer having non-zero delta

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCPaVAAoJEDjbvchgkmk+7LsQALh5SUFNwnHm/KPFC88As5yq
+OaKf0ALy2no38DMz8wFL4H14uyWpvX70w1uIcNFcXPrNsh9vhOmuhRfLNgRJA3k
42Gf+lK0jsu+zURsrU5Pg5155hMkUvYl3p61qjGW5pXf5SmMgUhEyxHkxVwcQVsC
NYdSjuMfvn77lyo0vSxgUV9D9KU8PohsctGqtYka8jhLwQIW50GYqI8D1Q2G+TpX
DeSHQ6SnOkIjTFvaaHItjkJD3cz3gCD8a1F+9UlHpB/FzDMs1IeHNBVHfVHuoAG3
POeBe9a1w6V2UPtUfEivDU+SNOcardEX3vet/+yJthJQwiB61kIzYQgayvLiAmyf
m1UK5ibKz2dOKOkS702OfkiBK7rvzWSui5FmH2TJFcLiu3B3msnlZ8bDE+XAzoRU
ajr/+1JgeJtMxmgoflVRmAK0HWyMWMm9Qwis1lzjKnod037AmeabD6Lq9v5nr56W
xOH9e6WT6gMyrf53Lb9tuVQzxmdMzxcWgxK1N1tfmVfs9jZaIFwXB1CjUbpI1j0t
5qQoukWVRNKhku1ngul8T8IrayolySYjiWwJOjaD2CPUhUyIhY54NPlVQiu5OL8n
VlDFzpB2GhjJKQe1h/6UIl1XXrCSI1Y946/TXKeClLbgNJ8Qsjc348NaoKLGwbWI
taU1Q0Jm+OKgeUdlxoEj
=ViMd
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
