Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaKZTpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:45:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39754 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKZTpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:45:39 -0500
Date: Wed, 26 Nov 2014 19:43:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141126194325.GV7712@sirena.org.uk>
References: <1415707485-28563-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415707485-28563-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LvG3mvTpA2cBjRlj"
Content-Disposition: inline
In-Reply-To: <1415707485-28563-2-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: max77802: Document binding for regulator
 operating modes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LvG3mvTpA2cBjRlj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 11, 2014 at 01:04:43PM +0100, Javier Martinez Canillas wrote:
> Some regulators from the max77802 PMIC support to be configured in one
> of two operating mode: Output ON (normal) and Output On Low Power Mode.

Applied, thanks.

--LvG3mvTpA2cBjRlj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdi1cAAoJECTWi3JdVIfQk74H/RuwhvDQuQSYjAciH7PhsDb6
fejs4N/80NdNeJtyOXLE2B8jDVxySeo9nu6iqWQjlWvqzWpzQkNVetnb+ZRQ2JA3
sqrcV+lG0a9MvJSXowYSgqZW+J0t5nC2f9r0+JD13bIqMLtYoTLoR4e2y55i/AxZ
TML5R7eub/bCG/DCOAmgv4qG42zcNT/RXBOu+ujmclvP1xwGHhUgTOHXCpUpPM4X
cJsBVWHqrrty95ga211FYOLNHVVDK3amW41/8Qg67M8nJq+fwp5z3JtbgI7HEW39
Jx7DDMTG73vwsamVuiVDPZjTrhINqJgWm+MtRERueLia8Qp15w/jkTPqihgLOwg=
=2eWC
-----END PGP SIGNATURE-----

--LvG3mvTpA2cBjRlj--
