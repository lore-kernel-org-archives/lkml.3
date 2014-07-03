Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbaGCQAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:00:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45113 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193AbaGCQAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:00:52 -0400
Date: Thu, 3 Jul 2014 17:00:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Wenyou Yang <wenyou.yang@atmel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140703160027.GI410@sirena.org.uk>
References: <1403451105-31929-1-git-send-email-b.galvani@gmail.com>
 <1403451105-31929-4-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nbmc0BhO2pdgImje"
Content-Disposition: inline
In-Reply-To: <1403451105-31929-4-git-send-email-b.galvani@gmail.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] regulator: act8865: prepare support for other
 act88xx devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nbmc0BhO2pdgImje
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 22, 2014 at 05:31:43PM +0200, Beniamino Galvani wrote:
> This patch prepares support for other devices in the act88xx family of
> PMUs manufactured by Active-Semi.

This doesn't appear to apply against current code, can you please check
and resend (along with the rest of the series)?

--nbmc0BhO2pdgImje
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtX4YAAoJELSic+t+oim9B2MP+wQCP1jqzEbsVStm2W4I9hjL
w3ZllUE9HV1D0OGNHt1UOwqZzkS2H7y2Kqf7MkI9VJ4yHPQDQ7yalUq2EHc2tj8j
kVF11bSRiiO0IY8TeE8mx9KH1e8iuNmLm50ICloDUgRA+A6mAk+tOwbSG7MWoRq7
RrHXeR8enXoMBoPNM0SCVM+pkidwp00d6rgWdLkxZe+zMbh/K2ZzA9fGztyfBJmy
+4tskcJ2HjPDd/PNtec7zvmrNyRoCxgwokveZKk77/Cdk4RGLFaZzVyUNdiCUIsM
YcKgKoFQIx+yp12HnxgRV3/xfZ96BTvPFOKn6JEgNSL8MelkTIOfBr5L7taab7tW
HIbDT6D8oRJguqnEOp6W+5nz5v0Mle93C1CvhZVJKvUdYIoYNb551URMtjOnNFRE
Tbhh2x4OkwxcOsGuowMcGmq5+BsdHG42bcM2xWI8xU7P2//+0dQhmB2Eq2dFaWrg
5u2YfD7364PgOHUroozMNhshr1Dll5HaROxW1AeNfllPpPtn3YvAQofEZj4g6lwy
VGhZ7A7ZTUFdK1++XhhY0MxJsLyxqZDir9uqsH7u5LB9p2xISldDpSeF7HQSoGhg
aH9aKG/anhiNlnyL768nevgfvJEadCkkvkH4jV/YV9wNm5kxCl2NRQTDBCvXNpWp
GYBlPueXEaQj5Q324Oie
=6BLX
-----END PGP SIGNATURE-----

--nbmc0BhO2pdgImje--
