Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3BUSKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:10:16 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61612 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3BUSKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:10:13 -0500
Date: Thu, 21 Feb 2013 10:10:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.66
Message-ID: <20130221181038.GA7510@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.66 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
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
      3.0.66


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJmMeAAoJEDjbvchgkmk+Y7MP/iQCixrVj9cMLZ7dl5OJpdFw
jZafkDWyFEi+jFRvERQtYYTUvZ5CYidW8Ja26gugp/h1hj/amLOb14ijW5/AnAQk
X01JeUo1mxW/TlOnFq7w8YAL/mgN+EdpSwAHwD3TN/V4/Fn2mMwOtYMRGEDmg1aG
kNl9BxxqpzjONEELsq33gICx0QfTaArjPaVKtZg8qRm03qjsX/4LfMu/dgXC8sJZ
pxchnU7RRfwB/WDET8MCZ60Ucs/RXrB/7Hk6zEyRc+5tKrkrVbXw5zHW70v/Lt6O
vl2gDyMsK05AeodSeqq4o3LscmEPNfDGvQ6/JZ1WTDcJT3SKSYwnM1hGAigXbFXl
QzzmsvOZjuS6R+kLUiIw/p+u+jYuhmsKTeeNzPgz5CODtC++39p8IevDYPSYTmWm
oH8PTeOmYwsjf2IozQUTzjCIJNJVpqnL977oKKScuelOBI5azQRMjeVL49ajpp6k
UYBYLGfmPHp03xjZ4KGElwTg9EEJCMrFd7z8pHZYfBwEO8Qe8pSdFex444cs/Jl4
FJ0zyrI8jzKUjGympNH4kUoHn44RKZykZUttW29bHIqW7kveXgN6L6xKlfEoeABB
YVeFfjupVyJQjgvqksKXJ1BvYYx77nbZkZG0pKuX1RlG5oe45On98X7/8niwU8V9
MvTqhFkzxQOxOnCDxe85
=5zh0
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
