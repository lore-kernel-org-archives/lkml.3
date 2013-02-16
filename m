Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3BPXqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 18:46:36 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50037 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab3BPXqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 18:46:35 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Driver lis3lv02d_i2c not working on Nokia RX-51
Date: Sun, 17 Feb 2013 00:46:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-24-generic; KDE/4.10.0; x86_64; ; )
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Ilkka Koskinen <ilkka.koskinen@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8212395.zaG7tlBeNB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302170046.26569@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8212395.zaG7tlBeNB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Accelerometer driver lis3lv02d_i2c not working on Nokia RX-51=20
with linux kernel 3.8-rc3. Probing for i2c device failing.

I tried to compile older version and it working without problem.=20
Then I bisected commit which broke support for RX-51.

That commit is ec400c9fab99d16a491cea17d27d0c6a5780b97c
"lis3lv02d: make regulator API usage unconditional"

CCing everybody who signed off that commit. When I reverted that=20
commit on top of 3.8-rc3, lis3lv02d working without problem.

It looks like driver is trying to use some regulator, but there=20
is nothing defined for RX-51.

Any idea what to do?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart8212395.zaG7tlBeNB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlEgGlIACgkQi/DJPQPkQ1KI2QCePuT8OLiiDBQekkY9vxdtDfdx
z3UAn2PfapssV1pS4h4gDmxkpMieu2S+
=v/vj
-----END PGP SIGNATURE-----

--nextPart8212395.zaG7tlBeNB--
