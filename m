Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3KASJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:09:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46677 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3KASI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:08:56 -0400
Date: Fri, 1 Nov 2013 11:08:21 -0700
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: akpm@linux-foundation.org, joe@perches.com, nsekhar@ti.com,
        khilman@deeprootsystems.com, linux@arm.linux.org.uk,
        dan.j.williams@intel.com, vinod.koul@intel.com, m.chehab@samsung.com,
        hjk@hansjkoch.de, gregkh@linuxfoundation.org, perex@perex.cz,
        tiwai@suse.de, lgirdwood@gmail.com, rmk+kernel@arm.linux.org.uk,
        eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20131101180821.GB2493@sirena.org.uk>
References: <cover.1383306365.git.b42378@freescale.com>
 <290c4ed99f88c1d07544bf5f8f0c9a1d09395bed.1383306365.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WnjMQ0y5QpAQNNgT"
Content-Disposition: inline
In-Reply-To: <290c4ed99f88c1d07544bf5f8f0c9a1d09395bed.1383306365.git.b42378@freescale.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH][RESEND 8/8] ASoC: pxa: use gen_pool_dma_alloc() to
 allocate dma buffer
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WnjMQ0y5QpAQNNgT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 01, 2013 at 07:48:21PM +0800, Nicolin Chen wrote:
> Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Acked-by: Mark Brown <broonie@linaro.org>

--WnjMQ0y5QpAQNNgT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSc+4SAAoJELSic+t+oim9w6sP/3GwUimdfWM6fWiK2wkrtCta
AO2WgBvYkjvFVzA3kjqeoD2CYSuBfItuwpjRT7v4SGziPDJGMNZY/6gQUr/3jtef
qnXP8TlcklLskOu4Y6UAf4cO3/onuwwTfJlgFI9E+9UCcyFzRj0PDInixX1Fvyrz
MjfQMRCVnyzICuN85FZqM27jbrGjZoaoe13QkQDnoCBXFpLArK9XmJZ+pRpReSxX
8xwZCt673ABzMdjoZcPYCRZqRYOZXFjALHwHW0RtdI0jPEWYUCjzCKeOiYjnZA1R
kIyWV4lpen7blglGtCn4r6Z/rX2JCLWGVwa/+XIxD65E+bzz+92yVi9SQITwtqBK
YpR6nuH/F1ncly4rrhzc2j+dzIms8IRDGRGJpE9hZ1cqWJWXbUfK6YyiXAY40yS8
YurvZKmaIjMpjdk5dykvgeLqFDgePLH3IUZYHliV309IWqpMcgZ4ZeCYpMKOgTvq
GKgK/XXV+QJoGDAwepmvUHcguD0XTFGIWXiumK56giky6izggAcu+R7cu7g2AcHa
SvFMdeLgluL/WgxPfqfsHYia/1KC1ltON3OPohbKU1UXm8ZpNwz2UFTK4jE8cbl3
HaQ3hvThmt8m7/pFHp4AxbaARHciBHg+0Zi0WsNmDu3URWoH4DDqIA6hGNVMO1kd
zU484RpgqGukceGnM8hF
=SJ9Q
-----END PGP SIGNATURE-----

--WnjMQ0y5QpAQNNgT--
