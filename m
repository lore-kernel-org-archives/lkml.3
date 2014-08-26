Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbaHZJxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:53:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52360 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143AbaHZJxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:53:07 -0400
Message-ID: <53FC58D0.6080700@ti.com>
Date: Tue, 26 Aug 2014 12:52:16 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] video: ARM CLCD: Fix calculation of bits-per-pixel
References: <1408538464.3858.43.camel@linaro1.home>
In-Reply-To: <1408538464.3858.43.camel@linaro1.home>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="NS5181eCm51hkXd64OT5eDcXTowo1Gsm8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NS5181eCm51hkXd64OT5eDcXTowo1Gsm8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 20/08/14 15:41, Jon Medhurst (Tixy) wrote:
> If the device-tree specifies a max-memory-bandwidth property then the
> CLCD driver uses that to calculate the bits-per-pixel supported,
> however, this calculation is faulty for two reasons.
>=20
> 1. It doesn't ensure that the result is a sane value, i.e. a power of 2=

>    and <=3D 32 as the rest of the code assumes.
>=20
> 2. It uses the displayed resolution and calculates the average bandwidt=
h
>    across the whole frame. It should instead calculate the peak
>    bandwidth based on the pixel clock.
>=20
> This patch fixes both the above.
>=20
> Signed-off-by: Jon Medhurst <tixy@linaro.org>

Thanks, queued for 3.17 fbdev fixes.

 Tomi



--NS5181eCm51hkXd64OT5eDcXTowo1Gsm8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/FjQAAoJEPo9qoy8lh71kuMP/0ROjT7sPvCqpRlkcqV+PnA5
XPWonbe30/WJQXFL0llCmJTQ2NhUks2xgK0yQKJwZ0ejX5fnqdixANt2Ufk+yGPh
Ys1qUSPExeAHG+Ts3OO11UzYLD8pc35JD9PmW9udb4D81FxbAptsDj7NYa+tyAy7
pBHIwNfA83oSm756X6ZW0cSDafwleEV/iEYrmPpBr/5LhFE3E9cFtPuR6+WcdZlP
xwSQAlEA/APXx6yOhHsyYyNLfMKpemevp/bb0cGCrKF8r6lLIanv/VfaeUJ5PlyP
RPsdW48FK7hsz8jspAkYzmwuRxavE9RU/fVRkG1dSSlzSEzXwAtxWOcGbiH3WIjo
dPqIeA2Vsh57JoP7/eewik6wZgCfzjjSgawuHFYT8Gy9EUbAmMDnE29049h63Jc3
fAPtkbKHMdPrS9NxV7fBIgZ/VARWpI2Zq49u0tAb1E1gU0velIlKhBq9TgkZNPFd
kuTu6w5DyhaMC1d+p5RN8GkqY5i6t3Hg/orpnp4POUE8xrZ63ROrxoLv+moY9EFm
24XlnAeZWLtANpOVYk7wmGVNG1x/ntH6/3ngTzNxhLeSTXybYPIXZlkSjR3EyaZb
AiBiN0KYmVm+x8I4qnFk3/65PMlEdwIxyZgJHnkt8xmbH/AgFIU9J5f1P9lQU7Di
oYhN3ClF5cVLO68x/ZR4
=/Jt/
-----END PGP SIGNATURE-----

--NS5181eCm51hkXd64OT5eDcXTowo1Gsm8--
