Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab3J1QCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:02:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51776 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab3J1QCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:02:11 -0400
Date: Mon, 28 Oct 2013 09:00:15 -0700
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Message-ID: <20131028160015.GA13643@sirena.org.uk>
References: <1382909086-10493-1-git-send-email-sre@debian.org>
 <1382909086-10493-2-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <1382909086-10493-2-git-send-email-sre@debian.org>
X-Cookie: You fill a much-needed gap.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 1/4] ASoC: omap: rx51: Use snd_soc_register_card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2013 at 10:24:43PM +0100, Sebastian Reichel wrote:
> From: Pali Roh=E1r <pali.rohar@gmail.com>
>=20
> This patch converts the rx51 ASoC module to use
> snd_soc_register_card. It also adds module alias
> to support driver autoloading.

You should really use devm_snd_soc_register_card() here.

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbooGAAoJELSic+t+oim95JIP/iM6CcdgQoi38u29uqn9Wngk
Ybk5NgxgSlgX5BEsPmh38fD2V4Vx+BrY6gPrMM0ibBCuWQGKDmsZRIvfdkbYxiXD
tysn3aKwrR+cL3AFteb6K3QByYo8JigxZoubvN/mRO+6EOt/k+I8RcA5uV+IwVXB
kkPKSibo6aBlnFj6kwqNaiEmhhVLfszIifgAuaibh9+MGjUkj304ZiID/0/Qww3n
55dZkUnqG2+co+fRgIR+95wq/gQKjN4AwiP91bEt50NpdcjMcNcxBUzjjgXdzJ7Q
a+gKjwlivR3SwsU3KRcrVDHnk4FmHXMZaNk9H/T7CNN5oKq4HTpCeNQcBYQD/5KV
/vvxDCQpBuGy/uAS5+5HP4UzNVLJDDkxi10NxXZbp1mJt1WIp4juCxFiMybnpNwU
wlpUFXoq9SKRvfDfvf/PcakO5CFkKSgbztkQxj+8dzbI1yRiKYQRvNDXZ/bbSD4+
E36g/xJJIU4l4ASPWYFHDmKIquypCli10zphQuKGkGD2OKK9X1xta9E7SqN7XvB5
zaDlkMndHss677LWiyQ+DzQIVmkL0e5OQrI/r/Vt8Qyf5Y/Es0NkZ25DLACPtfFu
oDJrGyINpVhZKNpIw4IasoVpdufy3yysZoOwHvLWAN5YMwlofNRb7Ktld8NKpVxU
V10ybJaRt9O2qlAb0+cV
=S7Vd
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
