Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaKQXs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:48:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45612 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaKQXs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:48:58 -0500
Date: Mon, 17 Nov 2014 23:48:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lee.jones@linaro.org, mturquette@linaro.org, a.zummo@towertech.it,
        lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141117234825.GF22111@sirena.org.uk>
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l+goss899txtYvYf"
Content-Disposition: inline
In-Reply-To: <1416184980-532-3-git-send-email-cw00.choi@samsung.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 149.254.182.38
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: s2mps11: Add support S2MPS13 regulator
 device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l+goss899txtYvYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 09:42:57AM +0900, Chanwoo Choi wrote:
> This patch adds S2MPS13 regulator device to existing S2MPS11 device driver.
> The S2MPS13 has just different number of regulators from S2MPS14.
> The S2MPS13 regulator device includes LDO[1-40] and BUCK[1-10].

Acked-by: Mark Brown <broonie@kernel.org>

--l+goss899txtYvYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUaolIAAoJECTWi3JdVIfQ+SoH/AjLN+bji/I/cMSMZH+MzlrJ
LyIgACLRdYUguhY5x1OYx81d2qb/h33csI7FteF4HuW228c9ZfJsVTwkTC2Lmr3X
r4to8odAvwUUOTIXLsvfiRmIj6ZRalvso2uX1N4qNoBhm84Coq7RS8mncr1EE12Y
Ngs2wcjA/VLRzKWK5o0NsKSf6MUINL6iJoh5UrhCPwUjuiyIvQ5bvGnEO1D1JkAU
mmi05rkY9mqTfM3PJwq36yWFw5Yxoy/UiWw+Hd0677S14916nuWoV2vU349mHyyo
VsxVZ5QXygUDBv+xGw9XrvHXZdI/R5vxbN7folfguvo9kzgpGC0bFGxOuwO3t+E=
=ArFH
-----END PGP SIGNATURE-----

--l+goss899txtYvYf--
