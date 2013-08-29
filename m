Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3H2Sfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:35:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42138 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab3H2Sf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:35:29 -0400
Date: Thu, 29 Aug 2013 19:35:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Message-ID: <20130829183524.GR10783@sirena.org.uk>
References: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
 <1375117247-6376-5-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yOCDj6dCdxu1mn4c"
Content-Disposition: inline
In-Reply-To: <1375117247-6376-5-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/6] regulator: da9063: Add Dialog DA9063 voltage
 regulators support.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yOCDj6dCdxu1mn4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 07:00:45PM +0200, Philipp Zabel wrote:
> From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
>=20
> The driver adds support for the following DA9063 PMIC regulators:
>  - 11x LDOs (named LDO1 - LDO11),
>  - 6x buck converters (BCORE1, BCORE2, BPRO, BMEM, BIO, BPERI),

Applied, thanks.

--yOCDj6dCdxu1mn4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSH5RpAAoJELSic+t+oim9u9QP/A4etYSAxgSKdDjyt4JWbjMF
r8SOzO0v4RCXkc7hZGCDlGFopzp+WkvqD9rPADNLeonhTr6VxramoJgCHH6indO3
ijTc1Lgb3A5+R+lIdEr+RzCNLdJMQ2SIWzCE3TsqWvK+XeFuj9W1KT7uORj7+/9M
gP05voQ4XE64EjRR1v8uB4sVm6t7TAZxhvj3ibnbgAnTeN124g0fWDgzBTQ7Tywc
EvuTQAPQXJvgJKZH1qRV1emTDsh4mxDV5TCn9RWDC32PmSTD7nAdMwbhr0WcxQ0l
8qhD9Yu2A+PkYYd1xs+HfK3r4875jgR2UsG02VZ5AwS4c8XFhQpKRcb7ZoqO2goC
1vx4yWWgCkRvKHCkU0uMd7CdoN+VfWVgw1+BPxfjo1NyiWDII9j9h4+vZqMgDdVb
7jHhBRTcJIfyAlg2W7j8a8xK9hpj+IPQvf5H9TI7CmYkrza41hdiOWVd6Aez4bOb
ZeJ5TF0c/DO3+kkSlRm+i1kQkvBoVU+WLjdgosleWGsHvyq/gQlsFycbpFMfB3Ny
t/GSSK7QWsVkbsVi7S/JyIlvtkQzm3skeNoapEsUT2iet9NwvS7Bjl6a1lK/5m4o
c1ufG5ITABDCatMlfLyxOiygwkk20tlU3ijPqpankYuOzPfZf0Dc81jr7j1OP3Fm
7YfmXd43yQPTKzP0pq0f
=c2Xc
-----END PGP SIGNATURE-----

--yOCDj6dCdxu1mn4c--
