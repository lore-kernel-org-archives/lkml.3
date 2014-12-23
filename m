Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaLWDRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:17:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbaLWDR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:17:28 -0500
Date: Tue, 23 Dec 2014 14:17:12 +1100
From: NeilBrown <neilb@suse.de>
To: Christ van Willegen <cvwillegen@gmail.com>
Cc: List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>,
        Mark Rutland <mark.rutland@arm.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Reichel <sre@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Gta04-owner] [PATCH 2/2] misc: add a driver to power on/off
 UART attached devices.
Message-ID: <20141223141712.74941672@notabene.brown>
In-Reply-To: <CA+Ot1Own-g=vjYhOygzVgNPspw6FgCHZqY8wQo31=ahf62E1gA@mail.gmail.com>
References: <20141219235827.13943.45713.stgit@notabene.brown>
	<20141220000920.13943.50943.stgit@notabene.brown>
	<CA+Ot1Own-g=vjYhOygzVgNPspw6FgCHZqY8wQo31=ahf62E1gA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/U6bHm36iY.Aa7Lm6V=uhK9J"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/U6bHm36iY.Aa7Lm6V=uhK9J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Dec 2014 17:02:04 +0100 Christ van Willegen <cvwillegen@gmail.co=
m>
wrote:

> Hi,
>=20
> One remark:
>=20
> +config SERIAL_POWER_MANAGER
> +       tristate "Power Management controller for serial-attached devices"
> +       depends on TTY && OF
> +       default n
> +       help
> +         Some devices permanently attached via a UART can benefit from
> +         being power-managed when the tty device is openned or closed.
> +         This driver can support several such devices with simple
> +         power requirements such as enabling a regulator.
> +
> +         If in doubt, say 'N'
> +
>=20
> There's a typo: openned.

Thanks - I've fix that now.

NeilBrown

--Sig_/U6bHm36iY.Aa7Lm6V=uhK9J
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJjeuDnsnt1WYoG5AQJdEw/+OyPHCqkMVZjxihrT7ftkBU5cWQINGUyE
wFFJQKwm2Bbs/UEbzmTXMyiPOQVcXoarbBWXq9i86Oad0XaNx7bmIXuMsiXkjW7m
yNTrATs7alWQyT3Q7m0Rw77LO8gAjEWNCnugLizZKzv1zIk70fahQ4mDU6XJU5UD
3Bsml62x/IahfZfWv32cxiWXJzcF6oHFefF5n8yxHqCnNdZjGaDDRyG6mGAvjzbI
4eqZ8mZSfuMlg5G6ioaFB7LYGMoT55vx0YUafgZdsdasB4KVHvAE+iihs1uMEjY+
1AbPYZfvhmXUkaxI/dON5uOHTWNKP+Mj8eZW5/4DQM8CahSErU101V548/hHMT/a
nalwX4irPfPLrWXatSA0ZgLYmmzZGvSJ7RsI5HLQp0JQ8ggbYK6HsvFH4TuSCw12
svflBNwYFt8c5Wlt2L0NMftwOU/P7Dv5e7OpIBW/1Lt08GHOIXY5HtZdW/G0Qa7h
wZwyYgH9+bazV6zbzZD4/oJJiSsTzd0gobO0+63zadnz1sY4xmoskOZEshtuUINQ
O8tneL5hGT4qOaDXXqIYb9keLMgSLx3RhurcA/pH/s2bk+UpZaJM3RTTYcJ6B2qJ
1b9/anQ68F0+6LHi4s/OHgeNTv5RN+VB/+DkMERWDtBCyR5pKF15b4u4EZk5Mprd
Fqf8d/DlfMY=
=6CCR
-----END PGP SIGNATURE-----

--Sig_/U6bHm36iY.Aa7Lm6V=uhK9J--
