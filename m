Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3LRN2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:28:54 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59377 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3LRN2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:28:53 -0500
Date: Wed, 18 Dec 2013 13:28:25 +0000
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
Message-ID: <20131218132825.GS28455@sirena.org.uk>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
 <1387286601-21646-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pE9oldV/ca00Larp"
Content-Disposition: inline
In-Reply-To: <1387286601-21646-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: s5m8767: Do not use sec_reg* regmap
 helpers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pE9oldV/ca00Larp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 02:23:18PM +0100, Krzysztof Kozlowski wrote:
> Replace calls to sec_reg* helpers with direct usage of regmap API. The
> sec_reg* helpers are error-prone as they mix u8 with unsigned int and
> order of some of parameters (val and mask in sec_reg_update()).

Applied, thanks.

--pE9oldV/ca00Larp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsaL2AAoJELSic+t+oim9thgP/16aWfvcIBKLXdGUUVPsOkzP
zlVmlFYk+VQmnIFysXfHBn7+ZkREAgCoNrW/LRM5lWB7961t8vWGLe6Y+4smzdvc
e1kU57RRF8LyOVYhF2f9TuCGZ+D7t9Ofo4c5Q+5HP9jhMIEXw22vLYR+wMBnRsjs
MllKRQFH2R9u0S9YkQnJng17iQ1GgNULE2TnHiWVR1LxfscUD5oJvld263Zw+iJE
CiybZ8x3MTdyjlH7Rc2d2crkNAQ0426PK7ETYnwpZTQqTTHrJOcy/N5oTxv+IbEi
LoktyvNzCMwM5MZ6Y6w3o3G041PVzMGETFWTc7aDOY0asXehPo0JQKSf59VXVQDz
rbeB0GYYftSTJro2q77gWRq+lDDMDrX9UkyhKJJBP+5SAwA3ehtKwM5Aot5O/7r3
lWmrPeUhjz/2s/tjUJhA6d2G4ODWMOQuuhTLm4e3qhFgaykzZ8z6+TD958S7GBZt
03pAGd/lK1EqIduDFl/9qWfAuBrOvi9g+USDMVKe4aDUX8HQ5wacdP/gEN2ulZ4o
Dt7+BhCCPu3y8Zp8DlERIf9an9JpwHo9adOhWDZZQRJX3H/kfbJ3Xd0QpwQ7cSUi
ajDxDggYo6uEftVCYdIUKW/TN6Yd4DggdErCQ7aGbui3MrbcadhJJxmOX4CbG/JT
VyxDFPDPxbAMJN4YYHE0
=6ISc
-----END PGP SIGNATURE-----

--pE9oldV/ca00Larp--
