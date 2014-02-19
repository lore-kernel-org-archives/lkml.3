Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaBSQie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:38:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57914 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaBSQia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:38:30 -0500
Date: Thu, 20 Feb 2014 01:38:17 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219163817.GW2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-13-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5lCRUm2Q1gYGGtIy"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-13-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 13/15] regulator: arizona-ldo1: Remove redundant error
 message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5lCRUm2Q1gYGGtIy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:09PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.  Remember to CC maintainers on patches.

--5lCRUm2Q1gYGGtIy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBN32AAoJELSic+t+oim9ehMQAJPLAMI8v3VXlHhkU21+rBno
JLY6LDbuSN5wQC5XhLvCgLOE96zFby3frqIS+xpcFLY6AINTM3DWZxLnpHNTqrL8
w5V8BNFc1bZEhqbNnhZnH1wzZprLu8+9VRJ8s3lMyA1i+JhHf513u2MgEZGsOpO0
8kMOdqrXu5D5e/Xm8M1ns43vv+NU/dEEeJWX3drR9E6uv3n6IcYlvGS5k/vqhPqW
/z6QswlU3LISWKjlnahKPtKArUY2D3fNH3ZgbMvWSg0drCUsoTqx1l9hX4M0EZSF
PVMEy67xxCL6Nnd3m1KSHjblX+suehzzyskfk86M/D0bAwyEpjBneZHPqc9vH+0K
1UbFEz1gF1WaKkRba1Cl0xCzVVASb10IzKXuI6qYEK4hH33pDRTimFbNF4gW7H4v
qfafvR3Qy8KUGU54Ph7KnsViT0mPMDbEHW4AbbbWoa/mf/+nrrUYjGjvBqHoh3gX
iKyirN8TPu+Cq5xcZTViIx/9EbAlcCgTgyPEMKknZim2oxrPJWt42GU5MgExrdXe
YovmO86XTTW0nDHmXPZOQ7l6DYgarpzzm5UIWXcjwFNYG1kOq7DiIQZM3kIun5o2
n+ZE1FE6p8GOrd4JA33tnh6jMA9L6gyByZdWk4gD4zQqhMa9+ZxNXoM+mo5pIVV3
qFAsiabLsc9hM48+EcWD
=2Sq5
-----END PGP SIGNATURE-----

--5lCRUm2Q1gYGGtIy--
