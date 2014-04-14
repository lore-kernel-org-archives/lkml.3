Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaDNVOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:14:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33114 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbaDNVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:14:11 -0400
Date: Mon, 14 Apr 2014 22:13:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Message-ID: <20140414211353.GF12304@sirena.org.uk>
References: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
 <1397462949-22379-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ADF8FXzFeE7X4jE"
Content-Disposition: inline
In-Reply-To: <1397462949-22379-4-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] Documentation: regulator: s2mps11: Document external
 GPIO control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9ADF8FXzFeE7X4jE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 14, 2014 at 10:09:08AM +0200, Krzysztof Kozlowski wrote:
> Add documentation for new property for controlling (enable/disable) some
> of the S2MPS14 regulators by GPIO.

Applied, thanks.

--9ADF8FXzFeE7X4jE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTE+OAAoJELSic+t+oim9pNIP/2T6oMkzDUIf1thSA4RP6XlI
c9abjXnQeyAjaaCQbsLs1oIFIbYkOyaXeJ3bzHfYciIz5TziH3GBJCO+WCY9ZoqT
ZQZqLgzlQzVo+0XyrDXMcE/ViBZIz5zoDgjXxi/aw+wyqWAyhvAc51xTAB/3CRgk
yE/52Xx+OFyf9KgL7LID30ABtd9YWiZdOj2yLXDoS7Y2oXeTZkdoGl2YnUBDpCWf
1hey/Vu2zYkLG61eUh3QRBDVw4ZfPXkyZOOTa2en1FIKEqeNaMsMq9qwUm8Xr5wq
+/j22U/1ccaLQsEVO84G00R/zoBrEwKBfz3aF82s6dNN9vPlg/HNP9yHbaOdTPLh
iZY07JGQuPq5kR6hdg9bVnrtxJq9EINzEKEwLvvwLStEAUkt50oH39+oOaFQMtnD
tOiQy/Hp3uLUgycR+3h+tcbqo14Q5ZJ0TOOaA71fe3lmA4D089qrQt5Vu47/vvpL
qwcgB0gpsFaGqIFe04Cytm+wRPFTt9EII3Ngck9RaoKzLPigHJYPagYDPzQ6wwzO
9jAHgVdUerzAEv5Pv/bcemcn6e1JBjuVErvoR3+8xql0xS3CT0gLbIEuALUS344b
OiQD4E6SOGi9U99+k50Mv5BO8iNoEaA3j7HPyH/K7fqMJbaQg76W99fu/8izl6s8
RKDDSje0WtL9/l5Uej6P
=1hlc
-----END PGP SIGNATURE-----

--9ADF8FXzFeE7X4jE--
