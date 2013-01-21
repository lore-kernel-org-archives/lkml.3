Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab3AUTzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:55:02 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:59445 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3AUTzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:55:00 -0500
Date: Mon, 21 Jan 2013 11:54:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.27
Message-ID: <20130121195456.GA6596@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.27 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/s390/include/asm/timex.h                |   28 +++++++++
 arch/s390/kernel/time.c                      |    2=20
 arch/s390/kvm/interrupt.c                    |    2=20
 arch/sh/include/asm/elf.h                    |    4 -
 arch/x86/kernel/entry_32.S                   |    1=20
 arch/x86/kernel/setup.c                      |   78 ++++++++++++++++++++++=
+++++
 drivers/block/drbd/drbd_req.c                |    1=20
 drivers/iommu/intel-iommu.c                  |   31 ++++++++++
 drivers/net/ethernet/intel/igb/igb_main.c    |   22 +++++--
 drivers/net/ethernet/realtek/r8169.c         |    6 --
 drivers/staging/vt6656/bssdb.h               |    1=20
 drivers/staging/vt6656/int.h                 |    1=20
 drivers/staging/vt6656/iocmd.h               |   33 +++++------
 drivers/staging/vt6656/iowpa.h               |    8 +-
 drivers/staging/wlan-ng/prism2mgmt.c         |    2=20
 drivers/target/target_core_device.c          |    1=20
 drivers/target/target_core_fabric_configfs.c |   12 ++++
 drivers/target/target_core_tpg.c             |    1=20
 drivers/target/target_core_transport.c       |    3 +
 drivers/target/tcm_fc/tfc_sess.c             |   12 +++-
 drivers/tty/serial/8250/8250_dw.c            |    2=20
 drivers/tty/serial/ifx6x60.c                 |    1=20
 drivers/usb/serial/option.c                  |    9 ++-
 drivers/xen/grant-table.c                    |   48 ++++++++++------
 fs/ext4/inode.c                              |    2=20
 include/target/target_core_base.h            |    4 +
 sound/usb/quirks.c                           |    8 +-
 28 files changed, 256 insertions(+), 69 deletions(-)

Ben Hutchings (1):
      staging: vt6656: Fix inconsistent structure packing

Bj=F8rn Mork (2):
      USB: option: add TP-LINK HSUPA Modem MA180
      USB: option: blacklist network interface on ONDA MT8205 4G LTE

David Henningsson (1):
      ALSA: usb - fix race in creation of M-Audio Fast track pro driver

Eric Sandeen (1):
      ext4: init pagevec in ext4_da_block_invalidatepages

Francois Romieu (1):
      r8169: avoid NAPI scheduling delay.

Frediano Ziglio (1):
      xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS gu=
ests.

Greg Kroah-Hartman (1):
      Linux 3.4.27

Heiko Carstens (1):
      s390/time: fix sched_clock() overflow

Jesse Barnes (1):
      x86/Sandy Bridge: reserve pages when integrated graphics is present

Mark Rustad (2):
      tcm_fc: Do not indicate retry capability to initiators
      tcm_fc: Do not report target role when target is not defined

Matt Wilson (1):
      xen/grant-table: correctly initialize grant table version 1

Maxime Ripard (1):
      tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler

Nicholas Bellinger (1):
      target: Add link_magic for fabric allow_link destination target_items

Philipp Reisner (1):
      drbd: add missing part_round_stats to _drbd_start_io_acct

Roland Dreier (1):
      target: Release se_cmd when LUN lookup fails for TMR

Stefan Assmann (1):
      igb: release already assigned MSI-X interrupts if setup fails

Thomas Schwinge (1):
      sh: Fix FDPIC binary loader

Tom Mingarelli (1):
      intel-iommu: Prevent devices with RMRRs from being placed into SI Dom=
ain

Tormod Volden (1):
      staging: wlan-ng: Fix clamping of returned SSID length

chao bi (1):
      serial:ifx6x60:Delete SPI timer when shut down port


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/Z0QAAoJEDjbvchgkmk+iEoP/1HmS7jnJaVCvr2kf7Hh2wUw
SO9ilmTjDqCZxLpOUPNa+WKy1Bx/rOMZR59w1bf1zwvBwPwAVY90lxmFrssf0f3m
Vwctx65ZLaPZZWjVdUKMpsimLrKLQMQ64/7z5uxRGUtc1aJYNcRuW6QwxAMEf6if
s2xntLNcgfOalMae8p1OQSdbNXRLHSh1MtxZ0wC9lBN5mP+AzYam2KQKXimV/HPn
EUUNC4Hgiv9j/cTqhimYKq2x8ezUpsBSBC4kYT0yh86JMz2BCx0lvGnkzt1PlD3z
cAjcE/IA6HMMhrhEOnfuzQq04IMVpET9HkAVdmwwDdGD3Dl/k5WP1/BZVwFZ5Dnu
xg/GLOLU/bY6m3HzjuYWf0uFynT+PMU4V/Z70EJkxs4NKe53CMzM4FNSaMKwUWNF
8gAtS9HXltGFzqEcNUVh6kO/h9qe0TaC5GKH/TgxbOrd6aIaMRSxPf/ssVlDAKMa
8tafJ48/7Zz6MwlHxbXI/OwTQdi7DSX97WSXXzZfXl7Tzlo00JIOQtVKe98U6FF2
nf4hLW0G1bIBrWgm5etb+ORXaBqKX3MxDlTVSoIBLfD/1m+6OS6BSvquXcq/kmpv
Hv91AWLCpE+thxDTB34lKZTViKoHUIZdKfKtRRqQj5CkXzyDpSqNOCirHmwGky+L
IXzAwX3cPb/kgRic58xu
=i3R+
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
