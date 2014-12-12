Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967854AbaLLNEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:04:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56710 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967589AbaLLNEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:04:52 -0500
Date: Fri, 12 Dec 2014 13:04:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20141212130437.GF11764@sirena.org.uk>
References: <1418305221-30348-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BDlG3CzP/kphk9YG"
Content-Disposition: inline
In-Reply-To: <1418305221-30348-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: s2mps11: Fix dw_mmc failure on Gear 2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BDlG3CzP/kphk9YG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 11, 2014 at 02:40:21PM +0100, Krzysztof Kozlowski wrote:
> Invalid buck4 configuration for linear mapping of voltage in S2MPS14
> regulators caused boot failure on Gear 2 (dw_mmc-exynos):

Applied, thanks.

--BDlG3CzP/kphk9YG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiufkAAoJECTWi3JdVIfQ+WwH/0xZzrp3W1H2NSE8arNrCoQM
U+QWyAYaueijKGfBTove/5SYsU+cVdz0l5Ov4WA8zTJ3uyEpF0FABWSBset5ZqqS
M/YI9tlE9tS3ZjkcNfbh3kQr1Jv0ZTnKGuu3VrfoLbWRF/n9PR2LC8aCsqfJgL0y
xmfhbi9N5wYhXJsd1B+MrGXtL5b6QCr+YJfWoZiyi+mgfzptet7C2elp1XG2wO8x
ycrXPkVuokVfkhF++0Mai0txINhyd7eXhSOt0n9CVR16cl+Wu7INcRryjlpqcaUt
02EEa7cBPgsJPG/YQIccE5VwGuazyAVw7shi7rx54aqefN+8Coovj3a1vHnuUIQ=
=9w6F
-----END PGP SIGNATURE-----

--BDlG3CzP/kphk9YG--
