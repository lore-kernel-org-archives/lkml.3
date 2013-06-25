Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3FYKbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:31:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53533 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3FYKbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:31:52 -0400
Date: Tue, 25 Jun 2013 11:31:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        a.hajda@samsung.com, Myungjoo Ham <myungjoo.ham@samsung.com>
Message-ID: <20130625103146.GB27646@sirena.org.uk>
References: <1372122518-6131-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L4gFVV/CladpyON8"
Content-Disposition: inline
In-Reply-To: <1372122518-6131-1-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: max77693: Add max77693 regualtor driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L4gFVV/CladpyON8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 25, 2013 at 10:08:38AM +0900, Jonghwa Lee wrote:
> This patch adds new regulator driver to support max77693 chip's regulators.
> max77693 has two linear voltage regulators and one current regulator which
> can be controlled through I2C bus. This driver also supports device tree.

Applied, thanks.

--L4gFVV/CladpyON8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyXGPAAoJELSic+t+oim9jL0P/22URezon9lk4T2fFeLL9r0p
VJ+VLCnSpi6JWnKRCqmA9Ucf5/+ADBuopyae84+/N2Eijcwmig9ilhpdOsj+JwM4
RjgtQ1oFsFpZxPhiP2DON46yKb+JPASW7VSIDp8y901vBP8Z4K7Ya10gKT+qwZli
LFQ/IO2eM4hul5KLf7g7L/veW+/J19EipDAy6ht2KeLkHVBOSEdVblRZItkg4syQ
4kjAOFjZ2UezT9k4aMjeyM+8tbVyGrDzBNLnEFSpj4NHiuNkGH6NTcM1jv9Dbu5v
EGLXJ9YJc9PFo0ZrkCnixsHsldyUmkvKfiP/eOapXrTR4qs3rWZFaJZQ06tiZyJ3
qFP3ffVIcNfSiHGmtMnt/2G5b/9ZAZYNPQTRt1u+7myTJALLqNAKHdNYCWV/1x0o
cFTBVP2npPDrYkJXtRRvvuPuAqTKwQNa40MGBBaCyIgVG51AKqP1V6bF7FNTf7xi
oBLvRsJMwiOKJdk99TWyAWyAyVpVVfAz4DPFZjEaV3QTs11qzR0lf90hEsHop1zf
XZS8K7d1q8Za35nWPwQrHNth7dF7oMqbZrPptFuE27UoErDzmROnt3vOT/MeWmyq
ZX7sc8l2LkUUWIkoQe9yS3YpNXPxYM2Bs0zDOYB4RkaM3aCAFVODie1ucBGJt07O
ZTiRyAYPLHrrjODiWt2Y
=L7Q2
-----END PGP SIGNATURE-----

--L4gFVV/CladpyON8--
