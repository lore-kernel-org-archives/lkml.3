Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaCDEdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 23:33:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55095 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaCDEdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 23:33:02 -0500
Date: Tue, 4 Mar 2014 12:32:36 +0800
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, perex@perex.cz, tiwai@suse.de
Message-ID: <20140304043236.GH2411@sirena.org.uk>
References: <1393555699-12752-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+d/pHe/DKO4mEuaF"
Content-Disposition: inline
In-Reply-To: <1393555699-12752-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: cache: Do the codec->reg_cache zero pionter check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+d/pHe/DKO4mEuaF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 10:48:19AM +0800, Xiubo Li wrote:
> For the snd_soc_cache_init(), the reg_size maybe zero and then the value
> of codec->reg_cache, which is alloced via kzalloc, maybe equal to
> ZERO_SIZE_PTR. If the reg parameter of snd_soc_cache_write() is large enough,
> the cache[idx] = val maybe cause the kernel crash...

Applied, thanks.

--+d/pHe/DKO4mEuaF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFVdhAAoJELSic+t+oim9JtgQAIUcWk17iIXHFK1VZyyYNkwH
GBF6p7k2s/FosyZjUGSSmjWa1grX1CYeUljrJxJOBvoGKgMT1AA2MpYItfvJZGkQ
mmv12BMlwpOBZ3mrBfSZ/1szJ+6RSM/1l/meFslPZCALTiO3a7EPJzCiT0Fe7yyw
p//a22U+UTEVqERXl+cYn3y7kgNnKnnl6MqhwG6Au1K0OswovAgkJd2fVIWl59Cc
0MXf5OUYSmgW19PGx6lyiGB2cf7VwxcT9newSp9yMLiMjiQKK/otT96Q/DrAVVdI
f1XkBiBng6/CfGxEntYOI53mseBiyd/D7Jyadb7Vy7BKASNlXedsrpXp24+++3Ei
qF1RSTc6YRG+0AcSjQeTXIyt3Jzya/gHKja2EHwJ82zSxa977yVSEOVA04A33oUJ
e1ZJKkYmceiJDc93TeM8h6xIzWoXErQyvSqowxVM2d0GvzIz6uqpnftP80bJFDT3
Y0Q8ou21T1leRMoFZBCUevOPGFfe1+9VHrbyy7mbrsc8qRzqR5P7aREt2SZ4NniY
/1dmV8B9f45zaGEabqhs5W0xKj5CexqeMdqh74J2ngaR8xDKwUmD4gfbtgrubi5U
2OKyjpu8SaO1gqXdt+ANDixfIacgE66feQRZXcjXn7mjC/OUv1Rtu+ntEN2xB+Nv
X7i5kcu6xeVzA37I1zz+
=8un5
-----END PGP SIGNATURE-----

--+d/pHe/DKO4mEuaF--
