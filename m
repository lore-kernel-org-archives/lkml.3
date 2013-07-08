Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3GHN3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:29:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41881 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3GHN3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:29:02 -0400
Date: Mon, 8 Jul 2013 14:28:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, sbkim73@samsung.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com
Message-ID: <20130708132833.GD27646@sirena.org.uk>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
 <1372510280-31931-7-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p/yOlLEfnp/ZBhGR"
Content-Disposition: inline
In-Reply-To: <1372510280-31931-7-git-send-email-yadi.brar@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [v2 PATCH 6/6] mfd: s2mps11: Add device tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p/yOlLEfnp/ZBhGR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 29, 2013 at 06:21:20PM +0530, Yadwinder Singh Brar wrote:
> This patch adds DT compatible string for s2mps11 and binding documentatio=
n.
>=20
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>

Reviewed-by: Mark Brown <broonie@linaro.org>

It looks like this should be OK to merge via the MFD tree separately to
the regulator changes, or I can apply it to the regualtor tree if that's
easier for people.

--p/yOlLEfnp/ZBhGR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2r5+AAoJELSic+t+oim9mjwP/2QfDTnCFu42IhGl188NCqvn
Gr6Cedkbl+B6HfYccavDqpo70R2QbjK6euQrBj+7EXSQPotsb77GNacflK2d2Ra4
qGxt0kyHSa/dqQuAW+Ts4CoVVNBhSv9CqeXJMCUKUPZ3GuNR3BYCvywGbcBYoRv+
7VbkvnQlh52DoPPnssquvYhbVia7iV5BStiuSNr4pqRshXhqIaTZeU61gWDHqTIO
RwLyeiEHwTFi/c3AesGxbg2HOuiXzPwHGXddj6FztUiIdM3c8Z/v8kcPdLMk/eUt
vdlXvAhNMM3GmQsekcXGu2R5UzYN1HFiBcr9+Ae/Ic35JAGH5pJJou440fU/KYgV
b+lGb6xmGcSw+FVcxNHfPZ+K8dUOSNk6e4wTR/WargAmn3Umz2QEb07Uuu6K11H8
nXP/zS0prvX5qorSbLEBV7nlIf0XCQdSNL5H7c6MHuCzW57M1F6Di7nlNc2kC6Eo
86hDuAXrn4SPlyHySArDbevyi+QUJSDAZs3LNZbYfBEwm2TkDW7saxF1Z4JWSOkY
Y4JLewMOzWf8FcW9TS08PSmKf8yLEtFcPKB7x8hVeU1lqplIZjhslAf4PcddBPWB
WiiMOQnh35ZW9RUNin+2BFlVzcxR4a0TqkFJh3s0GBmr20HhSnoRIeM5/L49HABa
v6qg/BGfoeQ1OZp2w8Fl
=Wx5A
-----END PGP SIGNATURE-----

--p/yOlLEfnp/ZBhGR--
