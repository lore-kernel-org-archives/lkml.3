Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaBTLun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:50:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47281 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaBTLum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:50:42 -0500
Date: Thu, 20 Feb 2014 20:50:21 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Laxman Dewangan <ldewangan@nvidia.com>
Message-ID: <20140220115021.GF2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-12-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qJYF9j12eEtZyQ+Z"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-12-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 12/23] regulator: tps51632: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qJYF9j12eEtZyQ+Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:12PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--qJYF9j12eEtZyQ+Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBev6AAoJELSic+t+oim9wU0P/3ladqNnIkCSYSBOTDzu01+R
HdhoOZjt2iQAZyWN1/eYXT0Lh6tGFoyYCkUkANttJ+9mttnz4BFqUyuzMyxKs7bU
fV6H3A5vkInmbsF/p7fWEXO8h0Cqv37kdjrOEwgStafCM/pHAi6HQao4FEY7NEEq
0yWW2rhi2dVd5MfaE2bCemAA1Pny5Ov83/Drh1dcfbcVbZ01XMdTkR0Q1AsPoj7R
IsYRP3evTj3m/3jS8EnK4G8hiPYFEZWf8Dj5Qxzd+dRrzBcm4swQeJd6S/mZk//J
HOb/6BqO01+V6E7IuY+dBZ0jLyVU1Zrj7/Y/24L4h8FuhAmlUcawaWYVafJNJU+2
hg2gmhPzf9u5kTpm+h7fNnKf7bbbeQhbNbrs86CKV7TdymDliqw60DdwtueRPywv
10ofWEuq3SgHOU8PwI1vbhgScW/KNtL33FUSZVK61TdbYEL2EKTzityzSbQ3NUnK
hZkuv6cLUjAz18Cy+OnmZN5lhz7ayS4isQmnzK8sfuks9xkFfz1fJHHU4/JlRbGM
yZz5VwLOnhWKQtPeuzDYa5TX83zc+PF58FD2nv2qN6RIHIeeJS+Flg5P1apfdh2A
I2uyDLZnIzX8E1KHnBlFyfhrEBvaGKaqqL0jdOtM3K3LSpLeTo11KNN3AZNyGrUu
L+KG+8XkYuMuA5kM3shn
=3IVv
-----END PGP SIGNATURE-----

--qJYF9j12eEtZyQ+Z--
