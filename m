Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3LRN1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:27:41 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54344 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3LRN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:27:39 -0500
Date: Wed, 18 Dec 2013 13:27:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131218132726.GQ28455@sirena.org.uk>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
 <1387286601-21646-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bWTBxx0QKOXH2iZ2"
Content-Disposition: inline
In-Reply-To: <1387286601-21646-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] regulator: s5m8767: Add symbols for hard-coded
 DVS_RAMP register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bWTBxx0QKOXH2iZ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 02:23:17PM +0100, Krzysztof Kozlowski wrote:
> Add symbols for hard-coded values of BUCK_RAMP field in DVS_RAMP
> register. This simplifies a little the code as register update is called
> only once.

Applied, thanks.

--bWTBxx0QKOXH2iZ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsaK7AAoJELSic+t+oim9dusP/3lpuWDkJa0hgz8csVh3qzx3
Yugfmy4d9fOY3bJFy794KHl3y2aM1lchrJec8DBzGgxcm7+fyeFZ1p4cpdkdsHLt
qoplTKBF+40FsDidQ7jthRedbbvDcLRh8MbZupeV36wp0N7L0mQgF83WUzO53rCt
fOOnaFEZNnX1qP3itvtkPRImBieqG8J7buxUkCGF8kuVXVVLcJgbKp13QjLgLg30
tdYilZPJOp+9vh8YapeaZ/mwwLaTdZe1rJ0T00huXbt+OK4t2H6EXnu7eHkz5abs
naMgyuwPZ8XmTd8QqBRQkaeaObX8sn1ngVX+so6VEDsS0oQ+Bbn60/gCJk5R5Hv9
HMQXWCDfWg/y7Aaz2B+xHVPkfHKnj4Mo6s08iMyUK5YopjbvEo534jz+HVSteqO8
7Yek67es5S1k4Dmzt/JYe7FxrIhBqaOrq1szsvbOAVbop70bIrwn+p0RKnxD8FMo
s6nqr0JqHMQ/DOuJGb/lA902STp6EMisyMTNcMsyTRXFGA3jGCE8nThFGTk6Sjog
orw5gGabBWXdTniGeskFK1KxED6O/9RzviRwbwcyQYVHspNVSqHKIR7T8U20G9Gb
2Ktnjsyrpibbb2WGow3hGKPXL+vn2yHsTvrx6fLl6Oc7MQrBygJGi8mmogdyBdIw
SWfCJvyvN0Fh+qiyqRIg
=kQ4q
-----END PGP SIGNATURE-----

--bWTBxx0QKOXH2iZ2--
