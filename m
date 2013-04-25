Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab3DYKqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:46:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38716 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755847Ab3DYKqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:46:16 -0400
Date: Thu, 25 Apr 2013 11:46:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH 3/3] regulator: tps6507x: Use regulator_map_voltage_ascend
Message-ID: <20130425104612.GK5019@opensource.wolfsonmicro.com>
References: <1366860702.18788.1.camel@phoenix>
 <1366860822.18788.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z+vV71AWp02Mr0PV"
Content-Disposition: inline
In-Reply-To: <1366860822.18788.3.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z+vV71AWp02Mr0PV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 25, 2013 at 11:33:42AM +0800, Axel Lin wrote:
> All regulators have ascendant voltage list in this driver.
> Use regulator_map_voltage_ascend for them.

Applied, thanks.

--Z+vV71AWp02Mr0PV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJReQlNAAoJELSic+t+oim9k7QP/inbfIjY+4vKadVHaDpBOp0x
3xi1lPu/mIOlaLl0zPHMsD/YVytUeEK/DxjHIxxrcQWs6n5fH6LEnPa+Yx9kxuok
nRyH2E/SxniD2wjaeIEU0vWI74zeeAxG9es8gv15Oc3IK+3oKaGOA9sryzZDoIhu
xU0cwoJfCyEtrUjtoqhFHL8Smpv7E+NKfVjuQyQ9YF1JD2Ha5A+7WN0DWrxynkdP
LxXMKlvF3aFHvxZw0pOGCUr2CvVX6L/XZAFX5HAcmS5DzEwtyMi9kiBuO7ad7A8v
J47lgfcdaRJvic2ERcPUbCjHHeSEb9iR+YUscbDEmZ9N7iBJE5OLVHV2OuSSb49j
gObcHseA+1DUrN7S3Tui4ChvGOQziwT70N10KQIjI3zDH8Ym9eWuR5inuFlNlWNN
GoSitJagKyA+1N6Vhl3xSaMf4WF/lgvBGAIeHH/F2UB2c/YN+yvTB4kx1Wm4Iog+
66+xx5hvX/PCUN5wYcGhpaZQ/P1IaBUFrY6u3hpO6DBWx2WAvfdwuT02Hl6Tnq8A
kL4g2xNqH0ZhFTqQddLwBMJOAehKRmi+k5o+UT3mKOxRSnqS7wTEt8kwvjbvzVUp
M0GqA0i/sA37a7RrGSW868bGn7SukapV6g/nQcWeOe13Ai7rb9ZDVvc7/p7xrEtt
Cu4mqOBgqcBl1ST+1UMp
=B6EZ
-----END PGP SIGNATURE-----

--Z+vV71AWp02Mr0PV--
