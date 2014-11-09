Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaKIMio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 07:38:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54053 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaKIMin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 07:38:43 -0500
Date: Sun, 9 Nov 2014 12:37:53 +0000
From: Mark Brown <broonie@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, peter.ujfalusi@ti.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org
Message-ID: <20141109123753.GO2722@sirena.org.uk>
References: <20141109120222.GA3815@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+Rs1qz93vBJxC1z"
Content-Disposition: inline
In-Reply-To: <20141109120222.GA3815@amd>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.249
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: sound: enable sound support on n900 on devicetree-based boot
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R+Rs1qz93vBJxC1z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 09, 2014 at 01:02:22PM +0100, Pavel Machek wrote:
>=20
> With device tree, it is possible (and encouraged) to build N900
> kernels without CONFIG_MACH_NOKIA_RX51. Update config file to enable
> the driver build in this case.

Please do try to use subject lines reflecting the style for the
subsystem.

>  config SND_OMAP_SOC_RX51
>  	tristate "SoC Audio support for Nokia RX-51"
> -	depends on SND_OMAP_SOC && ARM && (MACH_NOKIA_RX51 || COMPILE_TEST) && =
I2C
> +	depends on SND_OMAP_SOC && ARM && I2C

Please also update the config text so users have a chance to figure out
that this driver is the one they need for their system - I guess most
people won't know what RX-51 is.

--R+Rs1qz93vBJxC1z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUX2AcAAoJECTWi3JdVIfQO24H/05h2tWewTxcTo0Z/g7jpSv7
xHUVI2U49zpyTGArWFU9SxgqKYBYz5oHHKeJ6lTklLVfuZ7VaQooeWjf9EnLmVBc
Du6UV3Gojrtj72+RCOw4riDcgdxdbnLDDEaLm8TkSId0hFSp4K6HhULlAHTtdhCW
UdngZUDhKXrw7PG2+Ouo3tzzG0h9GVzmMkRKYGE5Yu7svJAb3AbTJYXRzKyRGQic
/zMjI2i0vlUBca1BbcYymOHnSqs/x1dJpy3PO+pLln+qN6es6UIXjZDexB3tygY5
1JFGhfT/qZe7DaXS7T8JqGkzOqzaOA6pqxX3rvfRm+WW5i3U5cBqCRuMio6xf7A=
=TRyJ
-----END PGP SIGNATURE-----

--R+Rs1qz93vBJxC1z--
