Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaKUSQC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:16:02 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33993 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaKUSP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:15:56 -0500
Date: Fri, 21 Nov 2014 18:14:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: support.opensource@diasemi.com, sameo@linux.intel.com,
        lee.jones@linaro.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20141121181418.GZ3815@sirena.org.uk>
References: <1416583748-6622-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1416583748-6622-3-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KIG9H3p2+yhemA+1"
Content-Disposition: inline
In-Reply-To: <1416583748-6622-3-git-send-email-d.lavnikevich@sam-solutions.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regulator: da9063: Do not transform local IRQ to
 virtual
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KIG9H3p2+yhemA+1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 21, 2014 at 06:29:08PM +0300, Dmitry Lavnikevich wrote:
> Call platform_get_irq_byname() already returns VIRQ instead of local
> IRQ. Passing this value to regmap_irq_get_virq() causes error which
> results in IRQ registration failure. This patch fixes such behaviour.

Applied, thanks.

--KIG9H3p2+yhemA+1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUb4D5AAoJECTWi3JdVIfQh0AH/19DTCS3ezwsSGPto3jMafJw
a4AMUZx2v6/ocaMHx2QzM7/8aj6E2o7uid8U3ondpzjthTQHsic7ww95hmaLlCQC
8JqA6FpPqeu8nGC40bMhWPUa2sbzqW4i6VirmymUQ/7GmyTQPN3LqN5aBc2Kn/bD
EWiCIi4YChwst+iUqgv7IotGK+Wtd0zcf+vdQ5Pf6aOLyyPBm/FEbXoERoh9kJYs
R2GnyOav837l+3t1FfDCf/dgTAxUV+Ie247cchMyPkar2U2zCrgpIqevv61sB06d
t7M3H8EDWRwNP9AmPXvjptrjUZQYRJXWdoV0HG0S1blTRNJonb1IaewJ0zJ7L+4=
=AJOQ
-----END PGP SIGNATURE-----

--KIG9H3p2+yhemA+1--
