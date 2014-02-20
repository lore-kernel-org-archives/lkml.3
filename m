Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaBTLWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:22:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47233 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaBTLWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:22:10 -0500
Date: Thu, 20 Feb 2014 20:22:02 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220112202.GX2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-6-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9pmxmTr7ulrPGhNU"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-6-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/23] regulator: max77686: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9pmxmTr7ulrPGhNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:06PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--9pmxmTr7ulrPGhNU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBeVXAAoJELSic+t+oim9XS4P/3YQSJxQNj5P6JpWfUlohIyd
y1QTibniEhnq5xpvM1mwnvTJJ9ORnyEGlnbe4H+VdW6dTaZ0vbwCTts4zEnRSMoZ
G+2is31Xeb77A094WMcvc52Kx1OEJes7NOkm1lctssP05Hm/ce1SM0Sdpo2wXOl0
4jHxrQxrFCGi3EqKNGd1seg32F/Rkda5orelLUQdCAm91jsEDIglGla9OubdK817
QXy8wGHUmeP1WwLvaD7fjA9+7RQGsZ6ACzHzs6W8X+XLSRetCkUBpTtRbNKL3LSI
uDW9PR1Etddgdavkc1kVpxWw0VEae15Qe/Q75MSpUw2OaqqDxJYGLtpB87G4U/3J
K93aFW0Poza4Oxa6SFQBLtvHZMwlkjnCtQ+0e1FjKAL0yaKO3WdPdf7RY+59Qjeo
+rE/TDW0eI/gPkTLL28HdwcL6TaKQteX2W92UHeg90U3QRPiDcLTrqczNwjnLdYl
ybRtilENeOCLhNhGgTraSAwt26wekStVFZCm12GAcd88mrOsOOjBaqkER2njqn4o
hVfxLuQX/+GzXOh0JlovXdAuCEekCqa6gRV0sHspFtYkeEc5dXBw6NpgtXYzJGxB
nDBS/ko0+ukbwv83xWNDUnGdJl5Zqlp9JXoBng5/m6uBBYzOfSsAfO2oky+QNgiZ
Jw6b3UpHNErFL7JXYLzN
=xW6M
-----END PGP SIGNATURE-----

--9pmxmTr7ulrPGhNU--
