Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaBTKYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:24:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47057 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBTKYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:24:44 -0500
Date: Thu, 20 Feb 2014 19:24:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220102430.GF2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q6u7BhfZawkb33IO"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/17 v2] ASoC: dapm: Add unlocked version of
 snd_soc_dapm_sync
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q6u7BhfZawkb33IO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:15PM +0000, Charles Keepax wrote:
> We will often call sync after several functions that require the DAPM
> mutex to be held. Rather than release and immediately relock the mutex
> provide an unlocked function for this situation.

Applied, thanks.

--Q6u7BhfZawkb33IO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBdfbAAoJELSic+t+oim9IZcP/0k8yPqL198zomIrDvdA44mx
tBBiG03l7zPGbVmSt8w7QxLFxAUisSNl/aLJ78b5etnT/ZhkjsNq2i0hA1iP5N1B
1xVv3iWou85uB/PaYm9WSq94yqDeMp08znqIZD7b57eE4B9DBgMVohaalB2X2XdG
konbOAQnZP0glCsJPateP2JBxtmDWhYNCPP/YUzxKc6m1Dzz8zkupP250VUIALAu
jqLquxLwfGSv7EkOgxglM4N3rpwbh3eMSygncD8MyycXKlZVgHtvqPIc+vOTM5Fa
o6L+h54+IdlypHKEL3c+KTXg7ihemtB1rn7vQe4cRZwgX3RJocR9Ge7C2iyan2eh
8y1R3JHk8Oa8MQ690zQ8DxMIkSqfvFPm1HrKnIVWMm4qbOC8KZwQ5Lc8d/hqyZSf
BOcsMEOI98NcyMYdI9ziXuufC+6cefpMpAeTYoXrCB5ygv4t/hPxzMFHR2Ng4fv6
h/K7ER2uazoXSTVMM+2DzHH/DGAWdlhfow9wHEiuf3YlSMuK8e3YZmjEmqXYT2yW
3NUn2k6OsNSnVFQO97ZVBlc/bhyuBUX+15ZrU1vEWNHp9ECd6cfaj/o16zSzpIrZ
hMavQGFPldibGl6uNWf0RfuYq0X1ds+DzeZXoJgok5RZ9OXYYE9PXovvLMED9FiE
TPH3u2DEF6pNFPdibaKT
=OZz2
-----END PGP SIGNATURE-----

--Q6u7BhfZawkb33IO--
