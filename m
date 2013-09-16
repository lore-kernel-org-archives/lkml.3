Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3IPXwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:52:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34957 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3IPXws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:52:48 -0400
Date: Tue, 17 Sep 2013 00:52:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130916235230.GJ21013@sirena.org.uk>
References: <1378949892.15915.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jIYo0VRlfdMI9fLa"
Content-Disposition: inline
In-Reply-To: <1378949892.15915.1.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: palmas: Remove wrong comment for the equation
 calculating num_voltages
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jIYo0VRlfdMI9fLa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 12, 2013 at 09:38:12AM +0800, Axel Lin wrote:
> Current equation on the comment is wrong.
> For linear mapping starting from 0, the equation is (maxV-minV)/stepV + 1.
> Since the linear mapping for PALMAS is not all starting from 0, the equation
> on the comment is not useful and misleading. Thus remove it.

Applied, thanks.

--jIYo0VRlfdMI9fLa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSN5m6AAoJELSic+t+oim9xVQP/0w4TFzRbGtvEIk9Z5o9BQEx
CPatoghZWSRiyLLheaCJNrMT4fzLok+5QqEyb6Ugs2+lNOhqeOJwsSvaJQ3W+RqP
vLDe8mBaxjcnkuMH15ZSHMUUTqKemNnUUIErvqNiCrKsPlwiGFoHcSeniMg5HtGd
f7vOt9l5kyRz0CohGJQunD/BNkxmoPwonjVNJMkKZ6uN+1g6h5lMawMMx9SaVGcC
lGczqsb8EdMT/YB8ShS/UAlrP6k8G7aD/nZBMpb63x4I2o3C9RUgi3+Gj517H0C7
aQbn0k5+izV42Eii85YrzVH8SOOO3+pxzXY+2wqhg8IabWoeXUPZ/FYBEzDg6fGU
eOXmj9r0OGIU40iy8AKyJqgaHGjZGdtEbFrmQ7oqb2p8sykjZf9KL1uN8wvMvW+v
El4OTkOCO90ymfrpfThW7yLw8FDYn2RUS8lHFKyRgcnGJw4WL3feTeJkq1pIVYnr
VgXMvgmlZBohyKaI5SZQu1KLBYKrMZOO3v51gVEhYmD3ahlvZ99HDXkphlc93eum
6yvqS9QiarhyOjVLInjofZ8KmMhQv7gxcC10Jvs2STxxQiadFKsCgo/YPqBkJucm
fXyIrixRMqIOLqRkiNIilL1E8TdXWKk68g9K3qkhCaZV31zhT6i6zvS2CU1F0/tf
m+NoXjBsRFXaKaTFPmVV
=fxbQ
-----END PGP SIGNATURE-----

--jIYo0VRlfdMI9fLa--
