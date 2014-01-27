Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaA0Uot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:44:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60360 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbaA0Uos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:44:48 -0500
Date: Mon, 27 Jan 2014 20:44:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140127204441.GZ11841@sirena.org.uk>
References: <cover.1390813480.git.moinejf@free.fr>
 <d99e90932aad1a644fa32ff22fd2cb56b830341b.1390813481.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yfuuGBTZ0Eg3HEy0"
Content-Disposition: inline
In-Reply-To: <d99e90932aad1a644fa32ff22fd2cb56b830341b.1390813481.git.moinejf@free.fr>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ASoC: tda998x: adjust the audio hw parameters from
 EDID
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yfuuGBTZ0Eg3HEy0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 27, 2014 at 09:48:54AM +0100, Jean-Francois Moine wrote:

> +		eld_ver = eld[0] >> 3;
> +		if (eld_ver != 2 && eld_ver != 31)
> +			return 0;
> +
> +		mnl = eld[4] & 0x1f;
> +		if (mnl > 16)
> +			return 0;
> +
> +		sad_count = eld[5] >> 4;
> +		sad = eld + 20 + mnl;

Can this parsing code be factored out - it (or large parts of it) should
be usable by other HDMI devices shouldn't it?

--yfuuGBTZ0Eg3HEy0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5sU1AAoJELSic+t+oim9RE0QAIPD/YcV74K5jaqLzWEsBfaI
Z4r3F3jVJdt/lrJQkY9rFLkot/4xftc49RqnxBQj7kRLQ+MLuD1mQ1zfU9IuX29/
aJgzZBWobFo8vTq29+G7LBu+zhGhwNooPJrwAF78boEUkzRrfAmGeIetLkG5b7yd
UYsrMcNFWxBGB7FVRLLWL4U4xjaVqrlDtnw75fXwSAhPkZ0JjjMZDsXqMdm+wkxN
U0LuBELRHcaFZ2KwTQe0AzCgFmiOcrJnQ1O7Pm0cjLkLxbYodNp3sbGjbH9iTewC
ZMCUv23BZoqERGq1jAFkjQKjM/SoWz69/ffBIt303G5NOBNfBIMnOijRPk+uiu7c
1ZgxxzxdeL38SW/n4l/67UVb9eDHpPrD0WI5JDD1YbhcsZG6GRmM13IvxdYmSVIA
TMAshvVHur1qCfOHNJqiF78NBzdjmDIv7I3t1uNBWVBMev17elaXNhnBVyuqKWoE
LeHKd0eh4uTfVXiykzE3CNrrS1rA+nu1D9MhPL+aOiF90E3Ys4iOIQh23NGq3G0X
PAeK9uZoH4fI3wQJTWXiCaLX5dnutQdXObXNxg6B4Arb+/kJFAUTguLx22IvjZi4
RMAq+TCXP5YRtptfqh/t7qHdYP4OYDvIPGel//cc2W1XbNpebBmjipDU2UVUbAk4
t1FTnLE1RuWivG9RrDOI
=9R2f
-----END PGP SIGNATURE-----

--yfuuGBTZ0Eg3HEy0--
