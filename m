Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbbAOQVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:21:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34218 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbAOQV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:21:27 -0500
Date: Thu, 15 Jan 2015 16:20:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20150115162057.GC3043@sirena.org.uk>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-11-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dOtxUVmLoGkyu1PA"
Content-Disposition: inline
In-Reply-To: <1421338359-27467-11-git-send-email-tomeu.vizoso@collabora.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 10/11] ASoC: tegra: Add a control for the headphone
 switch
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dOtxUVmLoGkyu1PA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 05:12:22PM +0100, Tomeu Vizoso wrote:
> To be used by userspace when the headphones jack is plugged in.

I'm missing patches 1-9 of this series, what's going on there?

--dOtxUVmLoGkyu1PA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUt+joAAoJECTWi3JdVIfQQhMH/1Ae3xZ0bhA/5G+1ElR9dg4Y
w6dHeGR/E20ff1p0s4vwmmZGuchIC3jzzue2o9KW6MgOQaFWhZ47/0ZjhDk+LQXQ
hhMV90kB3jm7YRbEOnK60El1RAW6X8If6YZ7UNtyNnExnxcnsj2HPtA/eGrZOc8t
ixa4BBZgL54P6n4n5HsOhwgqJC1fUEwXAqYJGcqMzrBdTrazd075w7XmlfHg5r2D
OHcyOcT0BMEnJ8kz5pI1exciBmF0tTy13c+pqnCrhXfclsj8IIk02cwUcIvQJhtv
6k0sjWkCMo2OLGkl5TyySZIEKNjUx5CeKjv5f07SXfEl9SvlwcFf6frJx7Pwi2A=
=i9Z4
-----END PGP SIGNATURE-----

--dOtxUVmLoGkyu1PA--
