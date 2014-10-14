Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaJNLza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:55:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53482 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaJNLz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:55:28 -0400
Date: Tue, 14 Oct 2014 13:55:14 +0200
From: Mark Brown <broonie@kernel.org>
To: Thomas Abraham <thomas.ab@samsung.com>
Cc: lgirdwood@gmail.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org
Message-ID: <20141014115514.GR27755@sirena.org.uk>
References: <1413274663-8836-1-git-send-email-thomas.ab@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b7fHDr8Jhawzdsln"
Content-Disposition: inline
In-Reply-To: <1413274663-8836-1-git-send-email-thomas.ab@samsung.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: add support for S2MPS15 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b7fHDr8Jhawzdsln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 14, 2014 at 01:47:43PM +0530, Thomas Abraham wrote:
> The S2MPS15 PMIC is similar in functionality to S2MPS11/14 PMIC. It contains
> 27 LDO and 10 Buck regulators and allows programming these regulators via a
> I2C interface. This patch adds initial support for LDO/Buck regulators of
> S2MPS15 PMIC.

Applied, thanks.

--b7fHDr8Jhawzdsln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUPQ8ZAAoJECTWi3JdVIfQ6TcH/2cM32ipy2UNpoEtaHB6X2LU
w8b5dZlYmyEJyRcOUT02Y49HedB6ZLdCu40qYpXV/X0Yw2uQiIoEEHS9e6CgVvk/
J2xACnpLFL+Ugns/JipzaOmDjhvQxKt6wqmpe7GUPQ/BH/Mux6f/kQlP8HuZJwQ1
YLBw34Zv02V3BApSB3fJWj9tQ+Z4LFvzxWKB8IiKI79OcjbX6SrIJwL5ZkJ86BGA
IbxDYiMu0pyeHGV0RRkiK3AVeCMvSJZcg3tkAH6UQuIfuKUq1lMcHr+tEKXSVOIg
QVUd/1W7PPkmaIepEJY02p31iW15tL2hiWhqWEZq8RAXNruHjNhsextE/SSBN74=
=dKFB
-----END PGP SIGNATURE-----

--b7fHDr8Jhawzdsln--
