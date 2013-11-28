Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab3K1NvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:51:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34456 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3K1NvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:51:23 -0500
Date: Thu, 28 Nov 2013 13:50:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131128135054.GK27568@sirena.org.uk>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LHvWgpbS7VDUdu2f"
Content-Disposition: inline
In-Reply-To: <1385626183-22990-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/5] mfd/rtc: s5m: Fix register updating by adding
 regmap for RTC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LHvWgpbS7VDUdu2f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2013 at 09:09:39AM +0100, Krzysztof Kozlowski wrote:
> Rename old regmap field of "struct sec_pmic_dev" to "regmap_pmic" and
> add new regmap for RTC.
>=20
> On S5M8767A registers were not properly updated and read due to usage of
> the same regmap as the PMIC. This could be observed in various hangs,
> e.g. in infinite loop during waiting for UDR field change.

Reviwed-by: Mark Brown <broonie@linaro.org>

--LHvWgpbS7VDUdu2f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSl0o7AAoJELSic+t+oim964YP/28tCdi78OGJMbguJcXPQ4sQ
uxanENcAbzRLiAwClmRSmi1jMHdJmNZkEC16uAnLS5qjnlDUuypr1pssijaZSagX
Not5U7KPSGdw3reSWh+JRU1o8Qp54OQN2gieQEjZlMs4rXS5YgftFRWtX7HjxG2O
TtsO9LK52q+cUXRiOO9XBU0yfEAAk07tF7hv5TzYaKHWquGXLI0+Klc3l+Ce4Kg4
E40MHbMhE9d7CIjMItloLjFPS37TEWrRQGh0RQt/HcQRTg9WLRC6n90w1EVBVFoT
AtKUfRwVJKoxiBbj5LQywGsu2TAUh3G7Pv1I0HSE2nLSXsD7NzpfJJyDUBfxbylO
FrabeAAlHXHkxxfe5m8FDA0BkyzI1dU50P8iyYbAVZAbK4dq0jRrk6Mi9qD+mE1f
klRhEtIP4IV8jN/IXUhzRbtVryUA/uSa60yJKY4oa+pgIzcWPR5TU9sPiNQEqMV8
sD135lcElbkoNEERtXMyx7p30e6FPQlTNcoy7H9vvu8YqNHYj1ZvSqSV7b/4aWmU
EpragRrl+5BVA1wk1NdmpTT0QgRp2AzkR797fbS+xwD/nyqzIWpgVUjsxH+Xc9H6
6i4WZn/MzGdssCu4nAGasoPeviif1WwGerXAGSzyqJBM/XF6k8AWZOs3ZdqdS9Ht
7ymNtwdjxVwRiLp2nHik
=6b4f
-----END PGP SIGNATURE-----

--LHvWgpbS7VDUdu2f--
