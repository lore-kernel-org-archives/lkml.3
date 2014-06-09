Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaFITz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:55:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34358 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:55:53 -0400
Date: Mon, 9 Jun 2014 20:55:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, k.kozlowski@samsung.com
Message-ID: <20140609195543.GK5099@sirena.org.uk>
References: <1402294548-10380-1-git-send-email-cw00.choi@samsung.com>
 <1402294548-10380-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NqzZQOWUM3MVZ6uw"
Content-Disposition: inline
In-Reply-To: <1402294548-10380-3-git-send-email-cw00.choi@samsung.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 2/3] regulator: s2mps11: Add support S2MPU02 regulator
 device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NqzZQOWUM3MVZ6uw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 09, 2014 at 03:15:47PM +0900, Chanwoo Choi wrote:
> This patch add S2MPU02 regulator device to existing S2MPS11 device driver
> because of little difference between S2MPS1x and S2MPU02. The S2MPU02
> regulator device includes LDO[1-28] and BUCK[1-7].

Acked-by: Mark Brown <broonie@linaro.org>

but a few nits:

> +	case S2MPS14X:
> +		switch (rdev_id) {
> +		case S2MPS14_LDO3:
> +			return 0;
> +		};

Extra ; here, and a missing default case here and in the rest of the
switches.  The default cases have no effect but are better style.

--NqzZQOWUM3MVZ6uw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlhE8AAoJELSic+t+oim9HZwQAIwBX65WNSXDxzwpXkWiG1b6
cNdMOv6uW5//OS7gXzVOWVnCSwT5jI+ysutYy2oREh2GWLEMrFTeH6NIRJsMj6g9
vf7NS6TtG5mKw1gtzGGHoCzOOAMj4Ih6uTLVEidGTA2CeJDB4kzMP2NTcpOWOI2C
Ap10cTKBftvYeaWKE9sfI0ruXcI0UORO586DPgiislmD8z19/iDH9fg6uJneyf2B
s87WjQXPfP1Z6wFJ0pU8Q4fGXqgr84hjaCeG/yiE3/pcvZEZuzu5I5T+b+r5ygin
gq2hi5qjpU2Vu+mSy5sKzyq9BgC6kBypUbTMaWM181BVH7g4vcVrr/dPHBHc8ZJe
1B0pFqBrdYGCFkoAqCBzltD/16q7JRXsA2z4XdRDA3Od5A3ZAXEqYQtiFqNeQdFp
GnYFUMcLqZrl5/COFwbnOcEyih+62RTrWtUET+rMPAJ6y0+e3BuRRm1Esr13El48
nK58iYJFQWP5bPlEb+e+Qu0DwDEldU0lokcK6eWELaKqQzUG9OP4mCC8qllHI5Oo
fhl2dXxKj2ZA2UmVEgMM/0z8gp4jOX9w0oy6NnIbFCegfhfq8UPsf4qoK9fnPFzu
SO/3BQ/VM+/FuhtIcVXwn0+vbhrBacZMWL2Qr9hiGeWFPSEZhtqqNtHxu6zAtf7B
dDtpOEWXsazWWpKs/31m
=Wjcy
-----END PGP SIGNATURE-----

--NqzZQOWUM3MVZ6uw--
