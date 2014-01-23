Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaAWTU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:20:27 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58689 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaAWTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:20:25 -0500
Date: Thu, 23 Jan 2014 19:20:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org,
        kuninori.morimoto.gx@renesas.com, moinejf@free.fr,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140123192004.GD11727@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-4-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TybLhxa8M7aNoW+V"
Content-Disposition: inline
In-Reply-To: <1390453370-29194-4-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH Resend 3/8] ASoC: simple-card: simplify the daifmt code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TybLhxa8M7aNoW+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 01:02:45PM +0800, Xiubo Li wrote:
> In the asoc_simple_card_parse_of() will parse the device node's CPU/CODEC
> DAI commone fmts, and then in asoc_simple_card_sub_parse_of() will parse
> the CPU/CODEC DAI's sub-node fmts, so we can combine the info->daifmt and
> info->set.fmt in asoc_simple_card_sub_parse_of() not while just before
> _set_fmt().

This doesn't apply against the current topic/simple, can you please
check and resend?

--TybLhxa8M7aNoW+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4WtaAAoJELSic+t+oim95aQP/iXfEhjJQ85Qj8IU4az7+aNk
2tW6kCvwypPEZN04p4Yp82Atf3GX/p8t4Oo70qaWnRYs++NdFdqWrU8NXXyQ0ku0
P4pKZjQh1ynK5k9b3fI9PGkecefMAfpqQtHU1iy/rOaUSWht9yWB2yvnkfc7XaQU
lONcmRVbCgSilK0mktUoqreChLdtkd/aytfYswWhkRIIjD9N3yQegt8eBZIan/hZ
zOKW3SYcZO3JjJibFCc5fZhyN+Ud3xDGY5MPuE/Kx8vNnqKpZkjRApw/teyCLQRc
LbXbn2ifMDqGADaWLjQk6YyWzS0pPqY4oY1F9/k4n+KaAQwKSoEZaafa0pIWzgBx
AIPwJ3jFfRxR6u8JD/4o1To7PPjF+0MAZpJkUV4lCUtN0Tb0gVXsg/h5rBYitoGR
fVh24hretXK1qibCA1nR/1b+ov5pWeDTFCmTtUkykLAW47rEwy5WSUOPddYq5sYZ
NWvZ1HKKwjOuHj81OoPv2skrwyJbAqkAvbFyYx5jLFREwzBmKi6hXlLx7t4rztPy
P5kFgIiJj+Z/tQ6IiUSOIr4MHrxxPleg47nEFkYMFgrRbnnTr8xdCQWcVwMqtMIO
l5QHO9UrbjEmPEKQy4CLSILX6klijStOZCylA6qZoPglxmgdw5k6qReycsduxSq8
KMS7OloBaa+jjvYscApj
=ZsJg
-----END PGP SIGNATURE-----

--TybLhxa8M7aNoW+V--
