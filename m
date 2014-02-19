Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaBSHvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:51:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60878 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaBSHvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:51:20 -0500
Date: Wed, 19 Feb 2014 13:47:26 +0900
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140219044726.GC2669@sirena.org.uk>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
 <1392765432-9111-2-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3vG/4P2kj9ZtXmMR"
Content-Disposition: inline
In-Reply-To: <1392765432-9111-2-git-send-email-mporter@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.145.86
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/5] mfd: add bcm590xx pmu DT binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3vG/4P2kj9ZtXmMR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 06:17:08PM -0500, Matt Porter wrote:

> +
> +				rfldo_reg: regulator@0 {
> +					reg = <0>;

What do these reg values mean, they don't seem to be documented in the
binding?

--3vG/4P2kj9ZtXmMR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBDdbAAoJELSic+t+oim9hOMP/RqduJ03BXUpU15KXSJHwI+g
4HqBYU7j12zning05Kx1qeanV8eQuoXuLUMvphmJ+X/9zeBR2QrAwf2Abc3ypdLE
QaBEyDjge0+Koyxnbb0+dxrGZosqSdLedp5t6RelCrSSX7antTmx/M0myXVE2/wk
cf3+7WeGeVO1oOqNVh03BeoN4Xiujou0dYJQJstko3thyR9J/SLawuIxTLrTPab8
mfnD56+V6U0YeF2kO7gNyZOoSiF2Ix36TF8l/iP8yh+FiRVEZOuwASleVD4JM5IX
64tlF1BXUjF9/Lf8U9LD7Fa/xHprmecko06iDocugY0R0oRRUM3UVGEu2N0iNi1R
CjK5d9Jo0ipdBA2gZqhcv9KpVZKCiqB2xVXzlTjGKXVWhj0A+rajV0i1CU/PhfCp
aXTh8nrLfkWWBx6hMU6BUso77+kqxHN2BxT9ouds6MMnczm7EWLQR6CrBfWP/F/J
STlq0uoVQMDB+RMPi7RE/+I2X7qBmeEMbwkphmEifqahjP6fSq+soLq5WcIpZDHz
/ejJu4F+sPUJLdjKHiY8Lkap21t/yfLNLxGv/qw1aCq0gAIsjA4T+1zgjPuPVGPl
7r2T+kBuAVBaKAUQqt4q3kxAujQ5+FUuVPHJD+fEIlaOH9/VX00Cro1/KlCnpakx
dsXcwZAJ69cDhNV3NtJP
=sj8G
-----END PGP SIGNATURE-----

--3vG/4P2kj9ZtXmMR--
