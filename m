Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3LRLRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:17:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58431 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3LRLRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:17:19 -0500
Date: Wed, 18 Dec 2013 11:16:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-doc@vger.kernel.org,
        vpalatin@chromium.org, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Message-ID: <20131218111651.GE28455@sirena.org.uk>
References: <1387343691-18985-1-git-send-email-wenyou.yang@atmel.com>
 <1387343691-18985-2-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wo0oCZYLrer5S3Oe"
Content-Disposition: inline
In-Reply-To: <1387343691-18985-2-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/3] regulator: act8865: add PMIC act8865 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wo0oCZYLrer5S3Oe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 18, 2013 at 01:14:49PM +0800, Wenyou Yang wrote:

> +/* ACt8865 voltage table */
> +static const unsigned int act8865_voltages_table[] = {
> +	600000,		625000,		650000,		675000,

Like I say you should be able to use regulator_map_voltage_linear_range().

--Wo0oCZYLrer5S3Oe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsYQgAAoJELSic+t+oim9mGsP/RR8EpXKHh26nSE/3XCi8KJ0
HqimjMSoVDvndMVh7aEqHlAMxFr0TH4bWx3p8FB03VoqKlIn9gm3u3SNRA0tAGQe
jCMGWWzaotod+hAjyyXALpdJ0leZN1cvgf78tWM3rHqvmCt1YyZ96XvdHElmQfBI
f2d/W5+3+v/gUtBuZ3duWaZitKJ5KmPGUPuMeTyWF3f622GFcvQuLyS0ekCnJU4z
OMPbG8o8N8HQceaWsz2PrWrZVqQxUXMJYChqk7GG+lUHh4ryxVAskoHTRWXBJbO0
57VlBrKkDYZN1c8iF8HF0I6QwFCDOk4Ti6Ae7JlKR5VKf8YdrjPFwoZUdJLvjp5q
SiCYr6kKcVBGAlcHrV0jfTlaL+pSfxO+KF3o3qzeCwN0VWNjYOJ0PYTmhZLeEtfu
oAR/DPVN1yj1SLOio/tkV/vMDd4nqXzBeS6/8iyHMlbzpxIOc6Lpnfqe9SrY++wY
E7imqdkJJqD9Y8gznjksq9Eqv/m4+xBy6dN7ofa8XwBMTOTphdxKHFkTuVtIOKA5
ulKW28uOO5zKegElr4dIejpynY0kPZcjSANZu7JGwlPJW+hIGGLvc6I7VusKzTXb
6lyW3TnnwBrQbG6OgD3K8Y+izIzU73IfRQAh8fLQTwlgocU3imhqHMSQDZrghvOW
G+bGnLjqqFLesJo2Wy1J
=39iu
-----END PGP SIGNATURE-----

--Wo0oCZYLrer5S3Oe--
