Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaL3QyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:54:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55980 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaL3QyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:54:01 -0500
Date: Tue, 30 Dec 2014 16:53:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141230165331.GM17800@sirena.org.uk>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
 <8da45b000fb1f9a029b30fcf5abe50941f45e32e.1419936132.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S/ANZfAJ/3KdLSz0"
Content-Disposition: inline
In-Reply-To: <8da45b000fb1f9a029b30fcf5abe50941f45e32e.1419936132.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 6/6] ASoC: dwc: Add devicetree support for Designware
 I2S
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S/ANZfAJ/3KdLSz0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2014 at 10:55:48AM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> Allow the driver to be configured through a device tree rather than platf=
orm
> data.

Applied but...

> +#ifdef CONFIG_OF
> +		.of_match_table =3D of_match_ptr(dw_i2s_of_match),
> +#endif

=2E..the whole point of of_match_ptr() is that it avoids the need for the
ifdef, please send a followup removing them.

--S/ANZfAJ/3KdLSz0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUotiLAAoJECTWi3JdVIfQ7+QH/2gSu/zAAUdqmNww5aTycacq
LGHRMLGL7/ZF+3wqamjy7+QHho80LQN5GddzGuQzRTQ3nj1xI36v0N8u1ttvUhEn
m7rhRm7QDT1AYkRo4qb0EyiriA2OjvAc6OttmX/ycJIvoqfhvY6QikjOKBd577Ak
zpnKGtw/PJoKkJcr9a8Z+N/aeOU8zqntJpfYBsiy07tWGHsmLkqvoOJ60wzNNnuD
pu43luelGqPkMpYOfDuJEr2AH6k60wZt9WPWIFlwtYVKK3MdNKUjx6KF9TaBxGgH
vqLTyFr32jxQJOszcIdaYEnlRPcMSLdMiWlKwITrUa49iOaoPKI7i98Z2H71UEk=
=pilP
-----END PGP SIGNATURE-----

--S/ANZfAJ/3KdLSz0--
