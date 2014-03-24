Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaCXFf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 01:35:27 -0400
Received: from ozlabs.org ([203.10.76.45]:35372 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbaCXFf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 01:35:26 -0400
Date: Mon, 24 Mar 2014 16:35:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the pwm tree with the arm-soc tree
Message-Id: <20140324163518.a96d786dbfdef5b71619d60b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Mar_2014_16_35_18_+1100_8XSLcTKA2hQQLeWf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Mar_2014_16_35_18_+1100_8XSLcTKA2hQQLeWf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the pwm tree got a conflict in
arch/arm/mach-pxa/Kconfig between commit c7dc7d49fa8c ("ARM: pxa: select
I2C_GPIO only if I2C is on") from the arm-soc tree and commit
557fe99d9d49 ("pwm: Remove obsolete HAVE_PWM Kconfig symbol") from the
pwm tree.

I fixed it up (the former also remove the select of HAVE_PWM) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Mar_2014_16_35_18_+1100_8XSLcTKA2hQQLeWf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTL8QaAAoJEMDTa8Ir7ZwV3SsP/2yMbSMrxU0a6WHNd/dtrGNw
lWK3+R4C2it1pKTjenZGWaNZQc/S8X1NfNDwYHqptQp+fjhMGa5hfog7mN1iHxg/
VxaQUM13j5VVpC+km7Dad2cRUHhy2LavytiqczUji37lZyBurKyVPv+YkMY7y4g9
61hAzeZUTMJWdVfCJFaSkbHUiOXXJ49XlrI0+g/ZVD3fTQDlXzL582wZczT4BWPp
mo8f8YgmCklWJbptvJ/ftKWp5KpJb20g1YPAG07bdourDR8zDgopSGcSMQPr/i/z
XgCsFc8pnRF6NK/Vs0mInZ8PGAX9nlpL7Zt1E7EZkC9YkyMJqverloam9Y2mV4sA
cENlxdZoGe3VK5DDBX9ZRnge/SKhY2/GE9WcxXRcHYHVLp0PSRGTJ6fAqHluCOTb
njeLryRZiSE9G0z9OOmr70OJkJORrmgRm1vYHrAR9E3K2MHQIlW7DZ7LJBpKYW4m
HVOMeZI100FrGnsltZEsnFMgVrl/iPomXYuoyblkiPUv2onyJRdfJctHAPh3xQec
IDpFiVQ9loIPwNGrWLypYbVSyej4xvNhuhJtHTK72F2bsGvVw9KL4aI1gr5uNBXd
lob6785Bx6EAW+JMLG1BUxfLrFXoO4n+f30/LjNoDo9xAU0hmQzXH25Xe2ogueTv
dOdR8NbDcCOeUBqF0AsY
=sR5j
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Mar_2014_16_35_18_+1100_8XSLcTKA2hQQLeWf--
