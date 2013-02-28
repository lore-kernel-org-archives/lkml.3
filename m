Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3B1JfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:35:16 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:55947 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3B1JfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:35:12 -0500
Message-ID: <512F24CC.2090906@gentoo.org>
Date: Thu, 28 Feb 2013 10:35:08 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130224 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Use config scripts to detect ncurses libs for menuconfig
References: <jlec@gentoo.org> <1361988458-18486-1-git-send-email-jlec@gentoo.org> <201302271937.49565.yann.morin.1998@free.fr>
In-Reply-To: <201302271937.49565.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2BPDMVULWOJUFMMCCOQWG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2BPDMVULWOJUFMMCCOQWG
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello,

> On a side note: is the old code still useful, now we use the config
> scripts? In other words: are there cases where a ncurses install would
> not provide those scripts?
>=20
> If the answer is 'no', then just trash the old code away.
>=20
> I've just tested Debian Squeeze (stable for now), and Cygwin, and they
> both do provide ncurses{,w}5-config.
>=20

I looked into the ncurses releases back to 5.0. The first release
containing is version 5.6 released in 2006. So I would guess we can
assume that every system will have it.


justin


------enig2BPDMVULWOJUFMMCCOQWG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEvJMwACgkQgAnW8HDreRZGSQCgupAxITEfKpOoZdOTAQ3hBe62
KgYAoJ9oX1tScTPd87eD3A2a5humSQR6
=g/v+
-----END PGP SIGNATURE-----

------enig2BPDMVULWOJUFMMCCOQWG--
