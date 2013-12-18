Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3LRNgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:36:36 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36952 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3LRNge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:36:34 -0500
Date: Wed, 18 Dec 2013 13:36:25 +0000
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
Message-ID: <20131218133625.GT28455@sirena.org.uk>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
 <1387286601-21646-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yahdd2r5OMEJJ+pI"
Content-Disposition: inline
In-Reply-To: <1387286601-21646-4-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] mfd: sec: Remove sec_reg* regmap helpers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yahdd2r5OMEJJ+pI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 02:23:19PM +0100, Krzysztof Kozlowski wrote:
> Remove sec_reg* helpers as they are not used anymore. These helpers were
> error-prone as they mixed u8 with unsigned int and they changed order of
> some of parameters (val and mask in sec_reg_update()).

This doesn't apply against the regulator tree.  Can you please check
what's going on here, I guess there may need to be some merge with MFD?

--yahdd2r5OMEJJ+pI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsaTWAAoJELSic+t+oim9ruEP/1u2tp+unLCNN1rUqh7SPMjZ
dd7CvoH/zpJxo0nYaLPVer9ei5fS9RJjdeU5VEpu7Y8ke+wsZvYbN6NVAC4y6lzL
s5MXAS8Rt2rf9u3tiAHLpAw7Hp5el/hBuL0H+PCshM+qK5rfyA/Qswpsjvp6LYPE
voEFF0TWOlAA3rypu4RBkYxswmVCsmnkC0Dk655+K6jLjoKtHpXFKNAaYKyz1Y7x
/k5wVeOye9XWVXMMlLKukMXH8m8swWr41ZIrgrhf113cx7rkOy34ANIeOkQ0+9w9
G19AXp/+vqoB36RagPRWe5/799l3vptDdqgVMQDV958q0sLn3PpUQGujDkIh2miA
08ILSVwOJURlgCOKHRhaTKOJFBQ1HzIK7q1/Fu9mUxYW+B5QgmdakT7bDtV7h7lg
WIxBw7RCLKIn/ffnGj7As5sKLl2qVFe6dKzD5f0/plIFR0M2FY6VtNoAwEhjX2kI
s0T2EkxFXmpCSydL4AyiluI5JsauXpYYbNdhH9hP0GceYRShEUZTtS2meFSi8wtP
vYJ+yNzvsATkIpB8TgO3UhMxTKaU9kKHLiUz5INxS6Ztdb/uoF9zrdI/+f7SszJ7
KeiJQ6tB7RbRDvL7xpaBDJwuKOykilpUgjgg0Cvsquqjhiy+Gq6NLjWldfUKWoRb
YMPj5ZjYERppdlPolb3D
=FjUx
-----END PGP SIGNATURE-----

--yahdd2r5OMEJJ+pI--
