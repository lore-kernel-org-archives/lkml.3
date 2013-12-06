Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3LFN7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:59:16 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44145 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3LFN6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:58:54 -0500
Date: Fri, 6 Dec 2013 13:58:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linaro-kernel@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, patches@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Hanjun Guo <hanjun.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Jon Masters <jonathan@jonmasters.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20131206135825.GG29268@sirena.org.uk>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <201312052325.02603.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+zeCMqFCsETNqUaq"
Content-Disposition: inline
In-Reply-To: <201312052325.02603.arnd@arndb.de>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC part1 PATCH 0/7] Make ACPI core running on ARM64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+zeCMqFCsETNqUaq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 05, 2013 at 11:25:02PM +0100, Arnd Bergmann wrote:

> However, as I mentioned before I am much more worried about the parts that
> are not done (or not posted) yet and that will be required to actually
> have working support for a real server system. Until we know more about
> where this is heading, I think we should not merge any of the ARM specific
> parts of your patches. Any patches that are reasonable cleanups and bug
> fixes for the ACPI subsystem should of course get merged once they are
> reviewed.

OTOH if it's well encapsulated, is going to be required for any kind of
ACPI use and gets to the point where people are OK with it by itself
then I'm not sure what we'd gain by keeping it out of tree - it'd make
the real system patch sets bigger and harder to review.

--+zeCMqFCsETNqUaq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSodf+AAoJELSic+t+oim9qgEP/iRplnHmJFMJSO2Q6KWQVpc5
qNmfHc5VNI6fAKZWzkPiIQHnOzTWc9ml7j6Luh9RxvTAgYXStv3r7xi0X2t+Q4Ey
sD84Y21ZKvJU9cqL6usiCDnTtsbWhroT6RIwW0c20z1e84+58KSpdfuDotHkRQ9D
lTgvfdOkNI3CC8TnZKryAT+a7vkDwL66wqa38v2LNYfA9sdNqCeKy0Id8m0D6cU0
hjlS/kvF2eyzj8F0URIOUc+e+LpNIa8hsLRr0aduNlJzjh1O35MxfsEawN/zPPSZ
3mjLRstqCcdLx2SSU0TapD16BG3Nnxa+/i7b2JKLIAfVWro1Hbu7/nUdNNV3imVb
do81y04Oia9T23tjwgLSNzI0ArEXIjy9Gblmap5eUERyS0yDbkvk92iemJhuvaNe
lbmssaAB72gyE1tAR6P5kfBedjSsibPCFNq1Ar0Sw1d+TyyHSPEIOvzlC2Rkl7Lm
K2tx263IFkgxpkCtB2M+eZ9H7WCAn4Rqwto+T8OdqQKzDpLCte1UFSpXuoDYQql+
K8gJ4nE4mKIpUwc1uOCxGmyTRSax/5x0fQCCAwmfR2G6pJW2yW6fgZDLNEduuVXN
NdzKnnvSvkdDzYSIXTM8Wg/rFBdiLNPKco9E7/DvTnFgXHTJZf+FMxFFmoQfZgG9
2dq5fwliLomvW5dxIUKt
=PlnU
-----END PGP SIGNATURE-----

--+zeCMqFCsETNqUaq--
