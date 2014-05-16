Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaEPShq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:37:46 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50430 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbaEPShp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:37:45 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
Subject: Dell Latitude E6440 & i8k
Date: Fri, 16 May 2014 20:37:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.13.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1792207.ZIRLJkuO5B";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405162037.41782@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1792207.ZIRLJkuO5B
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

on Dell Latitude E6440 driver i8k reporting total nonsense values

$ sensors
i8k-virtual-0
Adapter: Virtual device
Right Fan:   93450 RPM
CPU:          +57.0=C2=B0C =20
temp2:        +57.0=C2=B0C =20
temp3:        +40.0=C2=B0C =20
temp4:       +127.0=C2=B0C

Right Fan and temp4 are for sure incorrect.

Value temp4 is always 127 and is never changing, but value for=20
Right Fan is increasing when fan is more noisy. So it looks like=20
value for Right Fan is not correctly normalized or multiplier is=20
incorrect.

And name "Right" is incorrect too. Fan is on left side of this=20
notebook, not right as reported by driver.

It is possible to fix these problems?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1792207.ZIRLJkuO5B
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlN2WvUACgkQi/DJPQPkQ1LR2wCgrZZrmtYWMnpGjG704DDhjzt1
PSsAn1OaYOxI9IAc6hqLHB2HQxQ4lzEl
=Q5Yy
-----END PGP SIGNATURE-----

--nextPart1792207.ZIRLJkuO5B--
