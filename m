Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790AbaH0O5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:57:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36139 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbaH0O5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:57:15 -0400
Date: Wed, 27 Aug 2014 15:56:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Warren <swarren@nvidia.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140827145649.GF17528@sirena.org.uk>
References: <1409148376-12206-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LVpuKDCI6G5XXjRU"
Content-Disposition: inline
In-Reply-To: <1409148376-12206-1-git-send-email-geert+renesas@glider.be>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Make sure regmap_init() returns non-NULL on
 failure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LVpuKDCI6G5XXjRU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 04:06:16PM +0200, Geert Uytterhoeven wrote:
> Commit d647c199510c2c12 ("regmap: add DT endianness binding support.")
> added two extra users of the "ret" variable in regmap_init(), to store
> the error code returned by of_regmap_get_endian().  Thus from this point
> on, "ret" is zero in case of success.

Applied, thanks.

--LVpuKDCI6G5XXjRU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/fGtAAoJELSic+t+oim9JpoQAJi2T6IStufSMd8V2NbQD3wf
USSr6EJPHCMrqggabHqhbwBNjCcyxopmWKuRGjGdaB9Jpo1dzuYyFD6LlGXChUig
S7Ftq3bxpxr4QXXHXFryCipUsJfsepHWCQNIFn57D6JRXaS4gfzP58VzgGAEBtTo
/2enBZf9mFM+JMXFVupEMXkhTt+ocI7dyV4Gq88zReEDayfrvUTJdgrLMFHNRWIc
zyHRinDgko+UzUfTUa2TUV1Z9JJRGh7I0MfgV/4h5vkVQ+w0ni6A4vlcWVLnceEy
8SGaCBZWTQurJVFMtwpFJS49qihnDKZ7BSo8EP8sy+vPrR/Z6/EjckV6+8CZqStZ
RIrU000ft8b/3a3RUGD3bAaAnQtGodGS9y09CSf7+0NUeJlZR66TG8C2lywp8RVY
RXrjDTkaDpSa0dmuV1RH1FvBRM/EzUz/PD2bjikvO0tg4zPSumNagwmhqY/hV/tT
pstvwBQqSjIbn6348hajmn+fqv8lgHsRBh5FJ5UgO5XBiB4wGE/igLoooPkQkURM
SnrCXRIZY9socJjVZner8hd2gG5L+bggFBeTc53OMM46scA13Z8Jo1QO2DkHmcK1
9vxtG/RfE8s7uGD/Gqi0P13p0tExrGAUxJ6tfrGwTs1leRRiOC9Plsf3fdaWuF8X
JCgCGa1NKgwdQzP59Ygi
=mXaP
-----END PGP SIGNATURE-----

--LVpuKDCI6G5XXjRU--
