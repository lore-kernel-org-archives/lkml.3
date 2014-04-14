Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaDNITi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:19:38 -0400
Received: from kolab.o2s.ch ([77.109.136.180]:39930 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbaDNITd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:19:33 -0400
From: David =?ISO-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
To: linux-kernel@vger.kernel.org
Subject: clovertrail (z2760) defconfig?
Date: Mon, 14 Apr 2014 10:17:29 +0200
Message-ID: <2303923.o9BmGDLD1x@pagira.o2s.ch>
User-Agent: KMail/4.11.5 (Linux/3.11.10-7-desktop; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1890141.aB7ULZq1K9"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1890141.aB7ULZq1K9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

hi
i'm unsuccessfully trying to boot a linux kernel on an intel atom z2760=
 right
now but somehow the boot up process appears to be crashing the cpu righ=
t at
the beginning of the load process.
not even the uefi early_printk's appear to be reached, so it must be th=
e=20
setup.S or something like this.
since there are already a lot of patches for this platform in linux-nex=
t
i assume the problem is somewhere on my end.
could someone please send me his kernel configuration with which he got=

the bzImage booting on this device, so that I can verify, that it isn't=
 an
UEFI bug? (Also I'd like to package a kernel rpm for merproject)

regards
=2D-=20
David Lanzend=F6rfer
OpenSourceSupport GmbH
System engineer and supporter
http://www.o2s.ch/
--nextPart1890141.aB7ULZq1K9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlNLmZ4ACgkQAeZw77btGjrtGwCcD7ZkyUWPlhz8snrh18gBhXGS
a1kAnRjy8IZcVTkvGqd84qHCGa7G3Rtw
=Sr2B
-----END PGP SIGNATURE-----

--nextPart1890141.aB7ULZq1K9--

