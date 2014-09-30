Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaI3TZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:25:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55270 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaI3TZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:25:56 -0400
Date: Tue, 30 Sep 2014 20:25:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <20140930192540.GL4273@sirena.org.uk>
References: <cover.1411547014.git.moinejf@free.fr>
 <4b3d35a14461ed164956b7f5aa77b29170bc393d.1411547014.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gmhhrsDozM2n+uz5"
Content-Disposition: inline
In-Reply-To: <4b3d35a14461ed164956b7f5aa77b29170bc393d.1411547014.git.moinejf@free.fr>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 2/2] drm/i2c:tda998x: Use the HDMI audio CODEC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gmhhrsDozM2n+uz5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 10:11:21AM +0200, Jean-Francois Moine wrote:
> This patch interfaces the HDMI transmitter with the audio system.

Please use subject lines corresponding to the style for the subsystem.

> +	request_module("snd-soc-hdmi-codec");
> +	pdev = platform_device_register_resndata(&priv->hdmi->dev,
> +						 "hdmi-audio-codec",
> +						  PLATFORM_DEVID_NONE,
> +						  NULL, 0,
> +						  &tda998x_hdmi_data,
> +						  sizeof tda998x_hdmi_data);

Why is this request_module() needed?  If there is a good reason for it
we should have some documentation.

--gmhhrsDozM2n+uz5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKwO0AAoJECTWi3JdVIfQmr0H/i7ij3vyrmU4dk7pN5qms6Th
eTxnRhHPcUD5DhZxXD82yXG+iKdWpOEPeC1ndQv5lOwOEMzPB0CVUiJ1WoxmCSez
1qqvRawae184iIy0U4wzkOax95C5LtjxkHlFuM9xw0dAcLA9g4HZZWqXEPGaCJts
ivRx8ygkPRNi9rU0EHurYS6GXr/pTU7PCTtDTbtUp8Yd9RHxqE9B0DlKzuHwt4+e
VTvkcMKRNdUgRCY9h3CxfPSEPR/FO9eeHRsGgaBTkPZMzwKRb8Wjv4Hkt4Xp59u7
4l2wSXjh4mJrPAj2FQz3svQLE3vII8+Z1JbGySjY75YSje67j2YCCoupe97WQpU=
=FSmn
-----END PGP SIGNATURE-----

--gmhhrsDozM2n+uz5--
