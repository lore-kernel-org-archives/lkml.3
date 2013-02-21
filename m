Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3BUSKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:10:54 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55761 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3BUSKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:10:48 -0500
Date: Thu, 21 Feb 2013 10:11:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.33
Message-ID: <20130221181114.GA12281@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.33 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile               |    2 +-
 include/linux/syslog.h |    6 ++++++
 kernel/printk.c        |   13 ++++++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

Alexandre SIMON (1):
      printk: fix buffer overflow when calling log_prefix function from call_console_drivers

Greg Kroah-Hartman (1):
      3.4.33


--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJmNCAAoJEDjbvchgkmk+2N8P/2xcl272cNSabK8pSjD8ppT9
G+XtAKIKBSgJsAnDsOVmUm60+sEgsaSRNs8rY62/o4N3Jhy+ij14sbf0076IO2q8
af0HSOctT9Z0p4WxzzMBEUDh6hFp2B5p/yUzP4FvocIWfcQZev5INIj8X6Rf+QTb
Ymn1VlBzzwHCb804RPQGa8DyYvQePo2IU8AMFUt4YR25f5c2P21DxMdLO+/bQ46+
ih5ZqU6c/5yVsXG7T9+xiUiOuJ5hJW+Ssj6h5+TAOFfMfhzfjG+zgcm14Zhbr4si
wpLmfE+I+bnx5GJzdzKgKNgUy4OQLWXWRpKMBl5F6iAejkCyOV9HLLYPdNwgQr/m
8IUGJu1cuBO2g8E+8FppDJIJ24faE233C+U3cQttmb2gtG31HqGIkw99Y9QRejOr
AHvXlgSq5N5T4ezysJosSx6s/Uj/wznlm3Sk83x2BuvFPVzmXGRaDviQWAMIvsS+
ZmJhCdxj5Hl6bi0ShE7hQ4i5tNq7QVuTwO5wZZyV+qW/tB+L5c2yRMskZY54kAsd
9IZfilry//+jDfbVXwHfkf2sAs+0Xg5THcA00OGjLGDhjc73XgX7paL26HyOV6Qm
G4HBoa34U9OYh7az/yLoFiWs7lgemX6j9CEagbA18NEovGP15WNNqQp3AIxQNOv5
4Jh3gqkarMWrCVHiSBF/
=p5H3
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
