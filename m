Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaBDLSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:18:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35123 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaBDLRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:17:48 -0500
Date: Tue, 4 Feb 2014 11:17:43 +0000
From: Mark Brown <broonie@kernel.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140204111743.GU22609@sirena.org.uk>
References: <1391497089-6831-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kFkAOFB2pjIHo9zC"
Content-Disposition: inline
In-Reply-To: <1391497089-6831-1-git-send-email-sj38.park@gmail.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: fix pointer-integer size mismatch warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kFkAOFB2pjIHo9zC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2014 at 03:58:09PM +0900, SeongJae Park wrote:
> Fix the pointer-integer size mismatch warning below:
> 	drivers/spi/spi-gpio.c: In function =E2=80=98spi_gpio_setup=E2=80=99:
> 	drivers/spi/spi-gpio.c:252:8: warning: cast from pointer to integer of
> 			different size [-Wpointer-to-int-cast]
> 	   cs =3D (unsigned int) spi->controller_data;
> 	        ^

Applied, thanks.

--kFkAOFB2pjIHo9zC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8MxUAAoJELSic+t+oim9TsAP/1iKYzcQ3WCIXiD6tY5Xg92B
OOTQ1XhYLVLe5Jif1IJmbERz0eZeh/wbDFy1IOtCfDzVntvPwHv93APP5W62tbpH
ugDPQlGQco/7Lu/ypGT8Co4YeNTsuTIEvpKJc21mwTuQB58RNK0CfeVBkL75u4lx
14fhW001a4RLDSEipE1+6kyg5GppBoAO/CnvyfKcJoPAg7/CvdJTuUeiVdxOpcCP
TxpvSvxOQyigl2d79nMQ//YM72g8+VdTSoA3hNBixSykSgkSwiKg6ixzOeKG212F
OPoxemPUZcC/n9u5hlMFIlJfjotg8Qd07SFDUSwh5fHl+Ugogn97r7fped2vcm1l
3czbLOtQXQe55xWfqTXW3AwtJ8HuMzLgfL/uX+h7xH8f6+m05/FT5wKujphi0rNB
BO+CL5OWNv6ymfnHiPo8u22Fxxee0ajjlYWJbkASlLV4qhvQ4XaVFEw0B13k6wAQ
vrMCza5DXACcziigFsr+6rhAFbF187irrRrmFzXtSHkJwg70n5zjsdsQrzOjU363
VkO3+v19EyWdKZLd+7LQo7glATvIyXGIAuy7x/NCn2rziW+H6TMFIUmQb2PygGT4
DpuQp8WDBmng/IJG3K/hPJG2KIOAiPkjNIknRC/NQ4NAG5OO8jBA7Shw5lk+xMiF
mm3NBB0FQGs6lJR2hN/M
=tmnh
-----END PGP SIGNATURE-----

--kFkAOFB2pjIHo9zC--
