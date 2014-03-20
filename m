Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbaCTRcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:32:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41349 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbaCTRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:32:19 -0400
Date: Thu, 20 Mar 2014 17:31:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, devicetree@vger.kernel.org
Message-ID: <20140320173155.GG11706@sirena.org.uk>
References: <1395324654-8235-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XJC8d/km55BuzcCo"
Content-Disposition: inline
In-Reply-To: <1395324654-8235-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: Add new driver for ST's PWM controlled
 voltage regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XJC8d/km55BuzcCo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 20, 2014 at 02:10:54PM +0000, Lee Jones wrote:

> +	dev_info(&pdev->dev, "ST PWM Regulator registered\n");

Remove this, it's not adding anything really (the core is pretty chatty
already).  Otherwise this all seems fine modulo the issues Josh
mentioned.

--XJC8d/km55BuzcCo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKyYIAAoJELSic+t+oim96qMP/jxQwZ0by95KLR8s0/Ardnt0
rPCOD9Khi03/1qoLKkUMn6ScEgwPb2vd4klX2WUtxRJx0UvIaAR9AUHH5+HVtz86
mTiRXHl0CHwuxY6XihC9VdiJeEAgy/XXSZMqw1Cbdp1aH4x7UL1MdYyvv/4p/lUK
e6HQeJyPEZBxJqY/jcQFPHM+whGdzyAyTNLEG/OyKAMf5OhQQHgPdKe6zZHypAT/
H3mfUS7tnrf3+BAszuLnqd/465k2rHfKm4QyxnvAiqlcy1O4WO7LV/g+RRInuI6x
EPrksoZAq5QRGFpEJM7HeR7wGtmcpePcoBkHercuvQerZOBNrH4mzcTSkBT+X49b
J7XKS5sgMWRki2UdQBBw/N0r55HLGzrwSRPa7ZPUdw8o3UA7E/0Titf9otLNZxJF
8KAv75V0aLcs895BCjJdCL4dv7c1qSZSW1ltewvQ0loFbjZJ5w2hDEwJ3L1M7DRi
GNlmfNC8LUS7c01taBP1OpKujt602FEQqekhKxRti++dp06NCZIH6xxsnfICEa6q
LsVdY2wAz0au1TWLbDGGYmCiUyeZE9axEbGx1p1KmYeF4d6NBhOrrLSTgBn89fAi
1YysCtMtxVCeNLl4xfRBvDa7rbUpK7nObWXhWL72pWhYZczdHB6QOObaz1A0S3bx
WdZLEIokdQR1QryC6T3W
=+QoK
-----END PGP SIGNATURE-----

--XJC8d/km55BuzcCo--
