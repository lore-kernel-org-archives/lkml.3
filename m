Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaK0ONs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:13:48 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60844 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaK0ONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:13:46 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@debian.org>, Benoit Cousson <bcousson@baylibre.com>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: dts: n900: isp1704 gpio
Date: Thu, 27 Nov 2014 15:13:43 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1517250.8UISZE1CIg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411271513.43349@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1517250.8UISZE1CIg
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

in commit "ARM: dts: OMAP3-N900: Add isp1704 support"=20
e17337a26962943c27124a14b0794eabe76af437 was added support for=20
isp1704 chip with configured gpio "3". Now I looked into legacy=20
board rx51 data and there is gpio "67" for isp1704.

I would like to ask, why we have different gpio in board data and=20
in DTS data? I'm sure that isp1704 worked from legacy board data=20
without problem, so I do not understand why in DTS code is=20
different gpio number.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1517250.8UISZE1CIg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR3MZcACgkQi/DJPQPkQ1KtOwCghiZND4KrXvUZDfQqT8e6xiyT
Eb4Anizv9erK7THpjuwl+exRq1kg2Kgw
=b0GO
-----END PGP SIGNATURE-----

--nextPart1517250.8UISZE1CIg--
