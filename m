Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaHPViY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:38:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38993 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaHPViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:38:22 -0400
Date: Sat, 16 Aug 2014 15:06:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Jackson <Andrew.Jackson@arm.com>
Message-ID: <20140816140616.GN28623@sirena.org.uk>
References: <20140708114057.5ef3cfd0@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/TUrtqMIkCP4YtJm"
Content-Disposition: inline
In-Reply-To: <20140708114057.5ef3cfd0@armhf>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: tda998x: add a codec to the HDMI transmitter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/TUrtqMIkCP4YtJm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 11:40:57AM +0200, Jean-Francois Moine wrote:

>  .../devicetree/bindings/drm/i2c/tda998x.txt        |  13 ++
>  drivers/gpu/drm/i2c/Makefile                       |   2 +-
>  drivers/gpu/drm/i2c/tda998x_codec.c                | 247 +++++++++++++++++++++
>  drivers/gpu/drm/i2c/tda998x_drv.c                  |  74 ++++--
>  drivers/gpu/drm/i2c/tda998x_drv.h                  |  32 +++
>  include/drm/i2c/tda998x.h                          |   1 +

I'd expect to see the ASoC parts of this appear under sound/soc (even if
just a library that the DRM driver links against rather than as a MFD).
This should help avoid cross tree issues and surprises when people do
API changes.

> +  - audio-ports: one or two values corresponding to entries in
> +	the audio-port-names property.

What are these values?

> +  - audio-port-names: must contain "i2s", "spdif" entries
> +	matching entries in the audio-ports property.

So it's mandatory that both I2S and S/PDIF be specified?

The code looks broadly sensible in so far as it

--/TUrtqMIkCP4YtJm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT72VUAAoJELSic+t+oim98uAP+gPk82HZc6FQXkq2G4n0jnsK
wIu1BJGYUDZmzZfJV0UDfd3Y9v3h2OprohquiVe2hk6N7zm8wSFAOAX+qBIHUDQ1
LNjjsutE2ZMCpCai0c+rd7FdCPm9hdmxvVusBSJeRzRQUN0Fwbf9+79dUaSXUTu0
WwGiClwQ+VlRKIB1Cf1ezMut0tjUVEj4Oth+DiDOueDjuf6G/BKyF4tFOqSkcvbm
Ij9Y8wNmAbHhm1/ElN2Bbl75hxPH6NIcaJ/O3n56kATTsWtiKIVbkY5fY1PmLaRj
MEV70NIXkcjHJ3uo6wvn6es+9Xai6W9cxWF7QA78oB11aA8AxCFKsxaPMO5OsFqE
EN27i76OBK9JLXsndSUu8BO9BUSErOXiafkhSOvB9thg3ytaxxLnKwKOnUkHbe7g
SJcNSZxX9vzp2FK3WfEnSeLuSGeyxYnBWf4YkRZ0ZUNdcYB7ZGeZo3MdzuAXQT+V
XZCk/K5P+wEDWHbc00LVqLu6/T4FVuqEoGgo6sSJe1UEJkBXIKgQEE4shCZgJ0uo
kUrRixzuv6zbaCVdyBmLsZHXtqnUkA3BnAeuDaEsIMrDdd28nyC19XRLTdchkENy
Kf9UdppshdmySP1VkgN+0BPXC2PSRBNV9ZtLE6vuyeSb9gJ/fBWkDQFd2cEsBDa9
jomA8rHe0QZa0tRX5Xkk
=9pOb
-----END PGP SIGNATURE-----

--/TUrtqMIkCP4YtJm--
