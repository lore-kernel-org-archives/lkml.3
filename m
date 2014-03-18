Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaCRNK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:10:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34634 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaCRNK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:10:57 -0400
Date: Tue, 18 Mar 2014 13:10:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: <brian.austin@cirrus.com>, <Paul.Handrigan@cirrus.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <lars@metafoo.de>
Message-ID: <20140318131033.GC11706@sirena.org.uk>
References: <1394538091-19513-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qmxOb2Rj2UkcatHw"
Content-Disposition: inline
In-Reply-To: <1394538091-19513-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: cs42888: Add codec driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qmxOb2Rj2UkcatHw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 07:41:31PM +0800, Nicolin Chen wrote:
> This patch adds support for the Cirrus Logic CS42888 Audio CODEC that
> has four 24-bit A/D and eight 24-bit D/A converters.

Brian, Paul - any review comments on this?

--qmxOb2Rj2UkcatHw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKEXGAAoJELSic+t+oim9H10P/3U4FQW+bXFpOhAYpOB9WIWa
zkI7sUWKN53Ok64Q5Q1iPP5jVW4gRzyt/P/RVLemqNNkl64SaOMwR34DraSoY350
R2g5tJD4xn/zLN9TI5/fAvPgQEi58pXsmA15IpwT0i7VHwt35Ezn76tleurldinv
NYyFF0PkT2HNg37kmXaytRXyy2U8H/GKGPSsxnw+gkJR1CzGEPUczBgNFALP9edV
rcf+H1sIERaaVTfB4z+HrDnfMEJIVX+cxmRBYwiX79hQtMCWHh2DvvYk3gWwAOsO
GDpw3y2iXquUA7SL8hTxUK0fAPtp/VeCnfQNEdr419vY+V1w7ELzIwtnPUPbdN9/
sQX1V1n1Yd6BOkWE9zkKT4+SeGkKqBfv75bZYatOCZqgSMdG1O8FkMCn93+YigYu
1q7j75jPn5ItLNJOMlE6UZppvyKxMdaNQZJ4l/qfqDC0FVW7qEWOnvVasckwhixu
+3VvtkrFmtXhMs9p4iUEJSZme5Zs111EcDskeJgvLYS/ipzbS0u1VKqfdWAHpRuK
Jm3dSuiv1btcSxXcDGQUqKXeENDS9CyOVJ1sF1STi+0N7aKBnXeTYvVrxOUXx9S/
A23iDtjTMOzqE22DE7RXos6PnzuXgAU9DarBsrMzFVDSzlKgtivc9FD2u90vRsS6
1WIFGF07W5SOVN4vsKzH
=onGK
-----END PGP SIGNATURE-----

--qmxOb2Rj2UkcatHw--
