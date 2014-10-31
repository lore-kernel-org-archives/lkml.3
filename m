Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbaJaUbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:31:04 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39034 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaJaUbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:31:01 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Nokia n900 problems in 3.18-rc1 (was Re: USB Ethernet gadget on Nokia n900)
Date: Fri, 31 Oct 2014 21:30:58 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@ti.com>, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
References: <20141019090107.GA19132@amd> <20141029140943.GX2542@atomide.com> <20141031200318.GA6949@amd>
In-Reply-To: <20141031200318.GA6949@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4480910.6W89ptCjVB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410312130.58642@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4480910.6W89ptCjVB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 31 October 2014 21:03:18 Pavel Machek wrote:
> Hi!
>=20
> I tried enabling audio. It works ...sometimes... after fixing
> kconfig. But I'm getting WARN_ON, about 50% of time. Ideas
> welcome.
>=20
> 								Pavel
>=20

I see same problem with audio. Sometimes after reboot it working=20
and sometimes not. It looks like Nokia Bootloader set something=20
somewhere and then it works... I have no idea how to fix it...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4480910.6W89ptCjVB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRT8YIACgkQi/DJPQPkQ1KfcgCeJvT/fbQOYn9myWgO7PMvHj3x
JgoAn1vozxfGRUySmULRCi93/t1WH3i0
=J5ml
-----END PGP SIGNATURE-----

--nextPart4480910.6W89ptCjVB--
