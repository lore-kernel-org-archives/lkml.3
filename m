Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3GCSQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:16:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3GCSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:16:25 -0400
Date: Wed, 3 Jul 2013 11:16:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.85
Message-ID: <20130703181624.GA2991@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.85 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                      |    2 -
 drivers/net/wan/dlci.c        |   26 ++++++++++++++++----
 drivers/tty/serial/pch_uart.c |   29 +++++++++++++++++-----
 fs/exec.c                     |   16 +++++++-----
 fs/ubifs/dir.c                |   54 ++++++++++++++++++++++++++++++------------
 kernel/events/hw_breakpoint.c |    4 +--
 net/bluetooth/l2cap_core.c    |    3 ++
 7 files changed, 97 insertions(+), 37 deletions(-)

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Artem Bityutskiy (2):
      UBIFS: prepare to fix a horrid bug
      UBIFS: fix a horrid bug

Greg Kroah-Hartman (1):
      Linux 3.0.85

Liang Li (1):
      pch_uart: fix a deadlock when pch_uart as console

Oleg Nesterov (1):
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
      dlci: validate the net device in dlci_del()


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR1Gp4AAoJEDjbvchgkmk+IxcP/0WqhJaOw7ra/JjJMrUwrAPh
7ZUJb8T/WgiHkLBOkWLVwF7wMky7X5/FsS9SQElLmmPemkfgYEn1skIJRvkQFVkc
VwlGrhIBXybxWko1PXrrU1eJpXuGcxMzVw7BuN29/g7opisnjKOmIETGXZjursPY
u4mq58aqTX1kj3dXZnL7mj7oxVFFSZyvehY5NHxWNCi6kgTW0vLlf3+pmPrcnYjI
mqxKmLDrMk3g7WDVMedhtoQKXNXpP5YOnpKsGRJCN373asxH2SlJipraj3ZRbdQZ
6p6DpICVL/BSgL5NZEbgOqhMtiXxlLnxUluzxlAOGv71i9OeopqTr8Iaz/W99IWB
PZmhMKOGyOSABsgxcosVfeVEhuLCzJ1Ywxb9U7VbydCP1ieYMSCCEbI/8YS6s8jY
9tQDgK4nHu4xWJ4R/obiOf4XRbnwqYHN1omyizxg6zJo7knRzJll2HSLpF9NVpnZ
EBjQkSEsWibkTwwedDVHmuQ62honmw8yhZLzA9ND23VXMgluyz/Hrvis5a+JuJyr
/pxpdad2bNKqW1r2OvvFusg9rqicWZ/dq0D28RqkM3q35QdAeZMhInBtZ072kmJE
Siz4VsIWokhj6JR4hDTuPtE+e+suvo+9uRo12Ft/cUVMI7Bwr1ilKhPTNBq5nzP3
IFhAvR8qVaCt1h/nG3DR
=1XsQ
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
