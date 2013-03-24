Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3CXOPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:15:22 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:63175 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3CXOPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:15:21 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Date: Sun, 24 Mar 2013 15:15:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Juha Yrjola <juha.yrjola@solidboot.com>,
        Russell King <linux@arm.linux.org.uk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201302281905.48546@pali>
In-Reply-To: <201302281905.48546@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1494092.28VHEjonLG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303241515.16520@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1494092.28VHEjonLG
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 28 February 2013 19:05:47 Pali Roh=C3=A1r wrote:
> This driver provides kernel-side support for the Random Number
> Generator hardware found on OMAP34xx processors.
>=20
> This driver is included in Maemo 2.6.28 kernel used on Nokia
> N900.
>=20
> I fixed driver to work with 3.8 kernel and added
> platform_driver code to autoload it on omap3 devices.
>=20

Hello, can somebody look at this driver?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1494092.28VHEjonLG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFPCnQACgkQi/DJPQPkQ1IflQCdGboSqE1xTIQQYw/Bcs2ltoDa
Z+QAoMx7pXvb9x/rvl9ZOBfhXZNoaHBw
=bBo1
-----END PGP SIGNATURE-----

--nextPart1494092.28VHEjonLG--
