Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295Ab3LIRlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:41:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58383 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3LIRlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:41:44 -0500
Date: Mon, 9 Dec 2013 17:41:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
Message-ID: <20131209174141.GF29268@sirena.org.uk>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
 <000b01cef251$fc6df360$f549da20$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKRDem1CvcWhBwrN"
Content-Disposition: inline
In-Reply-To: <000b01cef251$fc6df360$f549da20$%han@samsung.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/6] regulator: db8500-prcmu: use
 devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKRDem1CvcWhBwrN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 04:08:38PM +0900, Jingoo Han wrote:
> Use devm_regulator_register() to make cleanup paths simpler.

Applied, thanks.

--gKRDem1CvcWhBwrN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpgDSAAoJELSic+t+oim9akkP/Ru3LPvm8CgBkhlwpG0/W8XZ
ugmNoB11MSriuPZSgica21TlhPMDtpqDIrkFX9Ie/V/6gJP7HwA/9iKNf5Od61I2
1/YfJ7AEReLoyYfBNIRauj5meRtOfnJLHTWyyeZ2mYtpvieeyqaIJK37RGpxQTek
c0wePMnTWv+yswjrvDAYR5yk6PuNUkaxrQeoPImz7Fb+WbrFcSNS7b0+2bOe2lIi
76021/s0d9Lr7C4PEIoGtqso+dg0R05reHxFto75wKylkqUoYDVvSLDSQ32M6orK
e9QYesI3EI76fJCsux8cecAufimAmL5R3ocorwdnQU/hFP/uSNqyXwyRMZYQIm90
Ws2Z4Cu9OdCEx7MbA2MYuZzCalkZmTZzWF+QufrD3QDOnC/pE+plI29y32C7JqQS
gAnf2kWc5L2Xs5v5UsThU3UpKM95Iras3eEkd564kOfSN/JD99Lo35awIXYooRvG
4x8rlAGCRpJ62PNHmr+1SeCvy1r3iIqyTkUzm6lGQ/XjcsMwHmOw+t0mEGHgZV8A
BVekAco/GiuwnK2ouV5fmOAPzorme68xlrc4v+3M52btgChXxtiQ/cKaaykd5tCA
ynCdrXz3+MB/+P4pE1wecXDEa2G5vpLFZ+poGk/pKFXlFpU57xHyu5QTgAsRQqAF
bOYZJ0wv0FPaM0uiidC/
=ybuR
-----END PGP SIGNATURE-----

--gKRDem1CvcWhBwrN--
