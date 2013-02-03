Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3BCUCC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 15:02:02 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56912 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3BCUB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 15:01:59 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH] bq27x00_battery: Fix reporting battery temperature
Date: Sun, 3 Feb 2013 21:01:54 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-23-generic; KDE/4.9.4; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <1359799569-5322-1-git-send-email-pali.rohar@gmail.com> <20130203034451.GH25016@lizard.sbx00618.mountca.wayport.net>
In-Reply-To: <20130203034451.GH25016@lizard.sbx00618.mountca.wayport.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1404671.A6SYlxvlcT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302032101.54487@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1404671.A6SYlxvlcT
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 03 February 2013 04:44:51 Anton Vorontsov wrote:
> On Sat, Feb 02, 2013 at 11:06:09AM +0100, Pali Roh=C3=A1r wrote:
> > Reported temperature can be also negative, so cache value in
> > non negative Kelvin degree.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
>=20
> Applied, thanks!

Now I looked at bq27x00_battery and rx51_battery drivers and I=20
see that both drivers reporting temperature in different units.=20
bq27x00_battery in 1/10 =C2=B0C and rx51_battery in 1/100 =C2=B0C. What is=
=20
correct degree for kernel power power supply API? Maybe other=20
kernel drivers have different units too... Note that my above=20
patch did not changed anything units, only fixed reporting=20
(possible) negative temperature.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1404671.A6SYlxvlcT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlEOwjIACgkQi/DJPQPkQ1IzugCeIeVhCYc8+dAj+h7kz0WuDvf8
g34AoLZBFAnu1VvUGFBX/GoDMmpWlOV5
=Zq7b
-----END PGP SIGNATURE-----

--nextPart1404671.A6SYlxvlcT--
