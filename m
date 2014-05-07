Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaEGTPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:15:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33490 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750866AbaEGTPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:15:10 -0400
Date: Wed, 7 May 2014 14:15:01 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/5] watchdog: Add API to trigger reboots
Message-ID: <20140507191501.GA7047@lukather>
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
 <1398958893-30049-2-git-send-email-linux@roeck-us.net>
 <20140503012243.GG4090@lukather>
 <20140503042925.GB5882@roeck-us.net>
 <1399463549.4536.10.camel@weser.hi.pengutronix.de>
 <536A2EAB.4000605@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <536A2EAB.4000605@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 06:01:31AM -0700, Guenter Roeck wrote:
> >This means we could have multiple watchdogs in the system, where we
> >really want a specific one (maybe designated through a DT property) to
> >do the reset. This isn't compatible with the "last watchdog that
> >registers a handler wins the system reset" logic in your patch.
> >
>=20
> Wouldn't the order in which watchdogs are configured in dt define that ?
> The last one wins.

It doesn't work, because the DT nodes are usually ordered by physical
address.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTaoY1AAoJEBx+YmzsjxAgiuwP/0jLf7SjpjdEk9dCxTYPgt28
lo6wNcEV84U1M2u4pa2BgPy4CJ7Nc46fXKrhgU/7eGa0Bg1JXEL0hIe8W99bjKWl
NJOqkkZLgg4reunhAS2WtGC1TstvyTW0TsP8G8U11wmzJyvZ+5bjwl9CAGwnfUxd
V0yHH9eP4qIVScgNeBqDC7xNP7bx6oJsRbklO5yvIvWVHhiV6ohwEQ/IWb6LP0cA
ic298YLfpuKPKagxrHdkgTC4u3HO0j7MxSR46gceok8shlk2YcJgXfTO84UR7GdO
FqwaJ7ACt1sfcM8gjtWehwwfHp7TwIWC0rt9QP++eyj6ivz9XIwgDiOBMlQIZ+3K
mk7qj/uWZldZE61d5E8V+b7/TeEK5OydIBbMMLKxffno915+1Ey3A9H3Z7E6yCxM
ADWPbFaaIpmXvToJ4bTL78GjtVMPxngq8q6TaQxrUjc4eMSJaNBif4gz8C6LYxVe
MmaA8l4Gxe22CysniMdade4uZs9kEK1d2r2wS7g4z+3xs8NIpSLjXOCaGfrL1F9i
3uRUVIsordpgLdlGunEGIilspXCGbU9duD4FieZ80X2XMpRRqK0XITVDDK5JW9x7
Cra9q4cYO8iT8fF/92Jk4i2c4J4VBQkewtAfFXp14vyGLA/dT+meZYT5nuszu3w2
bnPrk1UsH2Y9gv2TIDCJ
=bhWV
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
