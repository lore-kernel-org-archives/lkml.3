Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3DZTZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:25:25 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50792 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3DZTZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:25:23 -0400
Date: Fri, 26 Apr 2013 12:25:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.10
Message-ID: <20130426192521.GA23742@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.8.10 kernel.

It fixes a build error in the 3.8.9 release.  If you can properly build
that kernel, no need for you to upgrade (hint, if you enable CONFIG_NS,
you need this release.)

Many thanks to Shea Levy for pointing out the problem.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                   |    2 +-
 include/linux/capability.h |    2 ++
 kernel/capability.c        |   24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 3.8.10

Linus Torvalds (1):
      Add file_ns_capable() helper function for open-time capability checking


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRetShAAoJEDjbvchgkmk+2t4P/2mcdH2O7qektXLFbRC88Zz4
yhn0bqy0YjsIzRmhtU95gznBPQBjSmHO6vhNvtOaOOqTiYONrMKD4/ZLoorto1eg
9C9U5HXZx9DI2yTcK6QgPBWV4YdszckkwHWDC4bEcuR44eLcarNaJun2LtMbic0+
6retPvh+20QGsBcWZ6cbUZ6yETAOetEKCVKp8aOApgsN9leKtSVAO8jrwuPZ6f47
hxoLfsEcQdWnJGFPRL7kUm5mXTE5Mduvpx6YC4sau+NTM2gTt6dNLKdLSh+9Kdk0
sG62G6G+JSKrWdWPxvnUOpibrl9qoJTQw/ywlFwDau8xPtyIaKRvafxy7KXzbg5k
8zFW/Elv4NX7NxK+jECPo6C6eJVZN/wsbJJNmxVXjYQsNPgQJ4a6MHD063RsQITk
ZdofZkyNZX/C9rGJr36pDzKKgSNjioczJ8A3Ca4KDs0X8MqabO5w8scN4BMyNzsK
Vk2jVpOIg7uErzxFGrjM1p+cZWPeSFpSWrUeXC/kUPS6zcbUZO4b8a5yUlZp3aSc
cNsFLWZn1+dO7sSBbs3tyrNtqNC4hMoWp5pbcWQyHV1Etym90oZrR/+1hsTqlcUb
Vsv7mb9u5qZgoIHp1KjUcCNvb3C+n4j17x0hzI1Uixu9YwJHM9+/OsKJ/xj4r2XC
Z4XAILcRGPS3FsW8FTiF
=vAId
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
