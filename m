Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaBTK1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:27:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47090 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaBTK1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:27:00 -0500
Date: Thu, 20 Feb 2014 19:26:44 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220102644.GI2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-8-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2bhIMA05eV4p7XYQ"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-8-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/17 v2] ASoC: wm8962: Update locking around use of DAPM
 pin API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2bhIMA05eV4p7XYQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:18PM +0000, Charles Keepax wrote:
> The pin updates in this driver look like they are intended to be done
> atomically, update to do so.

Applied, thanks.

--2bhIMA05eV4p7XYQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBdhhAAoJELSic+t+oim9jegP/RpS/doXqmAv60CfYPG1InqU
qL9jS13sOqrm/WvykGqgzV9KvdoymaPgaXXXvFPXB5lfqK+Ojqx01Mw6WgNTIxRr
S66omDYbKlHvRpZD6oo1EMv6hXK8b48vu8t8zmOJgiBtnFybdUjQDBENtc63KMDU
bKBv4FIgtkgd7xOwl8zdQdGD4lWgdPYhmJQxG6FsSqPaz43jow1+8ZzgkeAYIbVd
NVbgtxsrMUlecEd9oGtk6jNMymEET80Irqonx4Z+Gz2TWgg3G9ViYK/Kc/SoK1bl
1DWMotk1ArtajA8y9XIoUOqGS0nOHPLRwu3U43Wk/2c1qRhXA8ethQSZ5iJYnbTN
Hq1rlQzlXQuJ1Z7uOvv/Ruk/ooek0IJFu9pOILGe2rg7BeW2j4iTJsGw/tdBEkoY
yu3Cr+ijFINTkTZlO68otX9xyalwlLtyeMHIw+Om93WigFXg/Q7sVrcTq1dw9cRW
B7H/0CLpKhW2jscsd6ggiPBpFuZrZcFV8GQBe8AMT/wMTkOsq9HaZ0hAM+xgjget
EhjboWtOB7hEKupsz3RJ1guHgboFmdzskv+baLAGcNij6wVeMDI2Mj07vOq8HUUx
pdpD/0uRA1guNucuMZXowUpxQ0oSG2SoHWglAIBaCsiI2tc51JKdmduFxXkq7GwN
XGcGysGZT8IIz1HhKgTX
=1Dse
-----END PGP SIGNATURE-----

--2bhIMA05eV4p7XYQ--
