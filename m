Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab3LFMzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:55:18 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38055 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab3LFMzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:55:16 -0500
Date: Fri, 6 Dec 2013 12:55:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131206125502.GF29268@sirena.org.uk>
References: <cover.1386333697.git.stefan@agner.ch>
 <7c948660cda4684d28fa97f82295ab84f6ef658e.1386333697.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xugVLPVe/nLWwmIL"
Content-Disposition: inline
In-Reply-To: <7c948660cda4684d28fa97f82295ab84f6ef658e.1386333697.git.stefan@agner.ch>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 2/3] regulator: tps6586x: add and use correct voltage
 table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xugVLPVe/nLWwmIL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 01:51:46PM +0100, Stefan Agner wrote:
> Depending on the regulator version, the voltage table might be
> different. Use version specific regulator tables in order to select
> correct voltage table. For the following regulator versions different
> voltage tables are now used:

I think this is the same as the last patch I reviewed but I don't see my
ack on it?

--xugVLPVe/nLWwmIL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSockjAAoJELSic+t+oim9sRQQAIuMIK4jteEQOBORNmVx7u+a
CRsMw+aZCoRF7NL/BiE8AfTZiMKLJSQrhoy8Q3IeNAYktWsWApXhpIG7+fXWDAJ9
OwDXGIkE4zGjrZnwvIW/N/b6h4lvR+y8DRaoWhJYfhd2JxghXarxllECCbofywyh
OeTwf68kVzWQsVeD+Kf7LrYDxRuPRs4i2tA7OruKOvXdyvLdfTuwWPcYeelNPwxV
ePrC+cUX58NnmG+GfM0o64hT7InYa4GhBVRxAmBt8j8xPQMrUVKl8i5M+kJdxTpw
QXFkYdl1uwQyAxz/Ma5+McXfo6ePd7EuGK2e2761PBdMYHE8ZDJk2RkKUgn6sAid
G85hg2lkhL/0zDnXAozfzVu8enPmYwWX7EDe0DHmdPO+6D7A51n2IMABpmt2DzOe
YX/VQ/lwAVENl5DTQz0lgTlXfytYXx2rN4cM2gUVMF16in+JYr1HNDSkbPwR3qSo
3ctr07aPnyRa8yF3Gqc3s/QbOnL/9NohY/N36AbyZakOg9oh2wuS/t8S/ygnsjV3
u1RdxQUWM3uO61DGfRqFURBLxDfl+dud3JC6aiMrMVYOfsXbaqiUReobCeJx9mPj
IJaRH8F2Oqerzg087I+9zyxrL/uUkO0mnSR/5arjYstFZrJWW3YiFbckIJ+oZ+94
SxXJGhlcBzg+pw+aW1ss
=lXOl
-----END PGP SIGNATURE-----

--xugVLPVe/nLWwmIL--
