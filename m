Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3CAGKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:10:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37943 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab3CAGKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:10:06 -0500
Date: Fri, 1 Mar 2013 06:09:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: fix documentation error in
 regulator_allow_bypass
Message-ID: <20130301060929.GC25302@opensource.wolfsonmicro.com>
References: <1362098694-8570-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <1362098694-8570-1-git-send-email-nm@ti.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 28, 2013 at 06:44:54PM -0600, Nishanth Menon wrote:
> commit f59c8f9f (regulator: core: Support bypass mode)
> has a short documentation error around the regulator_allow_bypass
> parameter 'enable' which is documented as 'allow'.

Applied, thanks.

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMEYPAAoJELSic+t+oim92Y0P/RK8Lcl8bPJI0VFTJkD1QH1I
+AvoiQrgIin+qpH5/KzPJ5lb9WDNDL1FULPGFYWdapTafKSVS9OZxq2R63ObD0xF
O84ZHYTZVEijrU+AWp6YNcvjaskqPMkEzABPINyZZlQv6MQJyG/ndPCQIEcDfyFX
dDHM51Nco3WkNUVReObFfHDSDciZy0EAcorMP2NsXKZKTmgsHAGP8JXRRJzeeTEk
2MSS2Yv3ePrl4+RK8YJXfR1JJjh/5deU4fo1mXqhTnet3ATqFnydrZMBcTl7kpjO
QUbp3iS9Av4nz3mQrOlhNVOCTyaykN9J1vvlQ5otaQUOiYjh9cr382/ES8NYx5QQ
ITcxjicfj/rSLlIvoeCLP65R6RI52W3CpGe/Rzu5l+wPfM//pEsWnCD6LhuBzyuz
6IMA/KJtM7i2CbbskYelJjoCOTVC3gVqF0PHWa3C6NCEhWaTpiqscPmoWAs9w7bb
B+/S7E/Y9b/5cuD3y7H7Zzdfj8HaPx83OP9ag9hygBCFQzPC1/LIGwG3lxF0UpYP
3sgtJgJUZEkCQ2V35KbzKm2nu7gnF9mbevEHSsGE8HoDJMVflI/Aa9OtVVAZQJwt
x9lh6zdvnAG02jABE6oP00BC6zGbE9WnKuARPnaaSCl972wX2XEu9Sz1sTT12WCZ
8rKsMtrtoxVrmaHQWeNC
=qoId
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
