Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaCGBvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:51:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57129 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaCGBvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:51:47 -0500
Date: Fri, 7 Mar 2014 09:51:39 +0800
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Message-ID: <20140307015139.GS13126@sirena.org.uk>
References: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
 <1394011373-4057-3-git-send-email-k.kozlowski@samsung.com>
 <20140306093826.GO13126@sirena.org.uk>
 <1394099334.25853.1.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1U3RZHujIvZE2R4"
Content-Disposition: inline
In-Reply-To: <1394099334.25853.1.camel@AMDC1943>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: s2mps11: Add set_suspend_disable for
 S2MPS14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1U3RZHujIvZE2R4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 06, 2014 at 10:48:54AM +0100, Krzysztof Kozlowski wrote:

> Anyway can you look at other two patches and apply them if they are OK?
> They don't depend on this.

There appears to be some external dependency for the definition of
macros like S2MPS14X?

--H1U3RZHujIvZE2R4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGSYoAAoJELSic+t+oim9G/sP/1/5AwDmpTSugc0VkiGlf9f5
TkzTHwBKQaGpqnqPCtApOUN6UUpiw4DJG7JseJDNI/SxB2xmJq6wg+5Z0FVkW9mR
23OXjAtFKOYZHzOwOPlee+oUt84B+oBgP+IvWo+yVq09P4VBpuQ01j3iJHrUh7iL
wzIVlmSrWbGJOrnDB4g/VsoZlw0TMhdmomD0gWczMRS18QSvvHD9lqiC+c2Edrr1
2w6e5PCnGHwNvGWBS3IxlE/5X5QxE2DKfrLuq1fn+e2cUSTueNK0yKLoJM0Q8x6N
44Aghzc4WA6RxHg1fXGRiwY2mDi8a4WN9EhJwtSDgoxeDkl5l61E1RO6yNuHw03E
ztJnLyyEWogwJPn73pSmvvJf8/S3NLxZI4GU1F1uFIgr5Nuaj1gCPqN39ipnxqMJ
VZTKF1LJc8ZiHPwfVKzW08ko+d+5siMFftH3kEDAvWTwB1SMf1ZPYONc4Vn4D4WI
P13qVA1H0QCCZPaHHnCPwj2indHORDzTOcL0djnmwxpzOS9yBj9u3b6Y21pYmII3
YvhQvW6p+p2D7e4ieVVdcqTw14ua1bxGh7H5poYzWHxl8PoDWedJcozfbQvm7PU7
Im2IjuF/1rKz2/vBuDLk0u1P54ksHhTMxgZ7YfbO2PhbQdnH11z6tKsftG4Wftny
Vj3lmc3yWXCgQwVWPScw
=3Evg
-----END PGP SIGNATURE-----

--H1U3RZHujIvZE2R4--
