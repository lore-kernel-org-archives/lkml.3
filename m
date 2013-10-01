Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3JAJXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:23:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35048 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3JAJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:23:27 -0400
Date: Tue, 1 Oct 2013 10:22:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        lgirdwood@gmail.com, rmk+kernel@arm.linux.org.uk
Message-ID: <20131001092258.GJ19304@sirena.org.uk>
References: <1380600664-20649-1-git-send-email-badarkhe.manish@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t1cwe7X0UXDc61Gr"
Content-Disposition: inline
In-Reply-To: <1380600664-20649-1-git-send-email-badarkhe.manish@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps65090: remove usage of IS_ERR_OR_NULL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t1cwe7X0UXDc61Gr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2013 at 09:41:04AM +0530, Manish Badarkhe wrote:
> This patch changes the driver to avoid the usage of IS_ERR_OR_NULL()
> macro.

Why?

--t1cwe7X0UXDc61Gr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSpRvAAoJELSic+t+oim9hjYP/i7SVX6VN20kcxecyEP0+m20
caj6EFEWJTVOQ4JrQDnvhzaQARHZ0ZHdmiIOKJ6M9bG8v/LL5HMExNqCBdF7/EEX
1PK42M7QtUpw7W5Paj+FCHgWJkjKNsfi0VOX4ooSxuyM8Grb94szulzy7NMeCXLa
joHz1A8Y0WNpexKuIPwWOqih5VFoCoip9h6Mz38ZSOpw7pTX0+G56oILKPfvhipJ
ZEnLW1guJfUbSqmw13shd+gqnUJ6u0z/vIF8upOx9BR2CuTRCgT6SNOuYyYpCUkc
oW1di4zXjXPDaf6C0eZ1KmAdQ0yIWelr2Gb7qxWkI09jn8nErjuBqBe3hFEWpkd1
+z/Q+ekDpVogMZObcssBVUI/GQ26l0gLlAB95ovwtBS23ranxDAAN31JBGr2MURt
YQf2L6n9PAYfNFMyD10ayRv+5IiF11C+ewj6Ez7aXjFbwdojj6BSWdiXcXmXWTIF
1fYuBtRbgg0/C/tOHn4uPvHlSzDdo3vF8vk2wIWsOiUAO7ezbW9gro3t/OqFInmS
zfuAc2yu6+AfFpbsh6dyJc2GpAT8X09rVTpsxdEL7c+60eBkzmogu5HZx9fqIePC
cSaX3RSSL3BELuTpJKEnZ9y0H1yb5/7QnfS808BuIft0FLyAPhDACrW7RpI3KAug
Y1cB5+0fKT+OECMYPYNd
=zrZI
-----END PGP SIGNATURE-----

--t1cwe7X0UXDc61Gr--
