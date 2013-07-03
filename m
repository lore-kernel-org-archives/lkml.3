Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab3GCJzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:55:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37489 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3GCJzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:55:52 -0400
Date: Wed, 3 Jul 2013 10:55:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, rob@landley.net,
        patches@linaro.org
Message-ID: <20130703095529.GG27646@sirena.org.uk>
References: <1372066617-23518-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z/W+H++SBmO57jII"
Content-Disposition: inline
In-Reply-To: <1372066617-23518-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] of/documentation: Update s5m8767-regulator bindings
 document
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z/W+H++SBmO57jII
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 03:06:57PM +0530, Sachin Kamat wrote:
> s5m8767 regulator is used on Exynos platforms which use pin controller
> to configure GPIOs. Update the example accordingly.

Applied, thanks.  Please use subject lines that match the subsystem and
try to make your changelogs clearer.

--Z/W+H++SBmO57jII
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0/UOAAoJELSic+t+oim9w5IQAIpyO2sJxDIvraWdfq29sjV1
nL2F5uDpwwO5ucVTbjO9kDxYXJ5SZu09FZgAuRygZdMhGYs/vvI+q9F2hKHEBI00
2FFLlOoQzJ9VRQopJZfeWS3zh67svQ2POC04CDtjMh7z3c4Y2DKFPCVSVQm74vIJ
1jxBnBQEOTMFJnCmtDcsh6q5TOG4Y+8MshR43O+dC6sucMGYP9SZjDfHZeE9nc85
DTN3kS3P7OP8b3YeVZdRUEecKIjkfaSURqrjrTyskLC6LP76ROP6vGh97o1e7jb0
TE37fDGhO0K5hvVF/msCbLESld1hTSU4E9yuWXtILOz/GmfMIPw1A7LFDxowxp8s
5seLBabLTihHWx2QZZfawPFptC/u60OKPQxY+j9alQQPHMYuXW7kSSoV4A4A7g/G
W3thlZz0G6P92ypRnVSvKwTn4m7mc4ofAF2SbIVD/m8ahe/0C3fRHpY7fyXFgJd/
6BtTAvjXEl1LvSRL9EM/kYE/cQeMXbqR34y9i4UrI1BW4Jop7salFakLthu4g678
wdr0EqrDou5wYJe4Cbjh6pU9t56BBaRhOsZmV2fvFp7x2Fks7N6928tgJiKjsHEb
nvlzuFL9tUlZ6D2Wzo5V7aLVVWxvRNdlcsiM9P6eCJkpph2Lkpj7mcaUOVWM8r8l
ZrHHzAdQRJYsih0qtYVJ
=Els0
-----END PGP SIGNATURE-----

--Z/W+H++SBmO57jII--
