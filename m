Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487Ab3CZOEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:04:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55845 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934470Ab3CZOD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:03:57 -0400
Date: Tue, 26 Mar 2013 14:03:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: spi-s3c64xx.c Remove unused argument.
Message-ID: <20130326140354.GU18316@opensource.wolfsonmicro.com>
References: <1364290055-2970-1-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BrzieSmlpF6NDzIw"
Content-Disposition: inline
In-Reply-To: <1364290055-2970-1-git-send-email-matthias.bgg@gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BrzieSmlpF6NDzIw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 26, 2013 at 10:27:35AM +0100, Matthias Brugger wrote:
> The pointer to the driver data is never used to get the slave
> controller data. We can delete the unused argument from the function.

Applied, thanks.

--BrzieSmlpF6NDzIw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUarDAAoJELSic+t+oim99LcP/3WDY5DYtGqofU2qs/7dQT5b
83ov9IwHn3TMmTQYYwo5nNzUg5mgQMEczKiGQNNSrz+Thwrs0q1r50fVMOhaqfKa
OS+jJMBYbGnGXQV90ZpeDNl61AGYpd7kc4YC8KgUn1h4saYaTxOlmycVMX0XGgX2
lXX8hHBSOgha87p5i8UMVC4ERb1cFGW8EfcW4S4hnIAehiBQVnkI7nJU4LIL+tzZ
sUJloVRfp7fHjmmBjAzH4REx7Nfh1jay5UugYW8XMVSSgEJWqLQ/FULa+EsyAdMl
m2MTvk1Odu3mI3bPMigKPIUxoMo0iRJjCkt3B9O3xIwv05dBu8RDzfrJyEGdqvIs
K3qvle4yEgYmOtJ/yr45KSf2wsnHT2QFOYriRtHuS7/40m85E9Fk50HP17tKFjvi
yHknwzbHi8xd2d+9VgGnE+P7ggsfwSVQvAY37vDseX4lN6wfoBxpUvJFJ9yDzQeX
lZIzQ0LKVxgFKmyVapCjYl7RlZGy5YPfmgH4RStfdNE5EEZOM4lnn5fPbRYMGntg
XLlUWv9upohSrig/v40Slx1HmFYko90iffWI9ZfuSSOO02h/cPl7YmjlMn6L3KDt
dSmYTCjTc5/2n/A+kEVqr9hag5cnlz0nOcE1SqCRzJcSBmi4aqhmHrnkLo1l/ZwV
qGmpmwklgXcqAH3pBQpl
=lsE0
-----END PGP SIGNATURE-----

--BrzieSmlpF6NDzIw--
