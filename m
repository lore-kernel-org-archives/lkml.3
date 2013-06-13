Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994Ab3FMSY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:24:57 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60644 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758970Ab3FMSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:24:52 -0400
Date: Thu, 13 Jun 2013 20:24:48 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [RFC: PATCH] err.h: silence warning when using IS_ERR on void
 __iomem *
Message-ID: <20130613182447.GB32574@mithrandir>
References: <1371072668-19027-1-git-send-email-mkl@pengutronix.de>
 <CAK9yfHywxyju2TbMWTfM7GBjjj8T5SdP8sc1j=VRRPxBesUtxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <CAK9yfHywxyju2TbMWTfM7GBjjj8T5SdP8sc1j=VRRPxBesUtxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 10:55:17AM +0530, Sachin Kamat wrote:
> On 13 June 2013 03:01, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> > introduced devm_ioremap_resource() and encourage to check its return va=
lue with
> > IS_ERR(). This however leads to the following sparse warnings, as
> > devm_ioremap_resource() returns a void __iomem pointer:
> >
> > drivers/net/can/c_can/c_can_platform.c:205:32: warning: incorrect type =
in argument 1 (different address spaces)
> > drivers/net/can/c_can/c_can_platform.c:205:32:    expected void const *=
ptr
> > drivers/net/can/c_can/c_can_platform.c:205:32:    got unsigned int [nod=
eref] [usertype] <asn:2>*raminit_ctrlreg
>=20
> CC ing Thierry who has solved this issue some time back.

I had sent two patches, one against sparse, the other against the
kernel, but none were picked up yet.

Thierry

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRug5vAAoJEN0jrNd/PrOhEukQAImslUECKlNnop/mkD4qFcT3
S3VvHF8y1fnk/y+GWXlUu1P9uUEAKOZvv+biFeHTvxu6YMSz4G1asFp+9+kEaSHY
tEYVlu7PJI7RZVzT84iMkjXRB+1U4nmki1Iaus6UFkgswKi/FHCWqVb8c93qfz53
al8UQj6qwNGtIcVXAXdcPBfxX4Co/pGKpBXLpPgkX66QRALeuWcp7C0HxfZ/1Ijq
u1a35XNrphwmN7HCdxXYNpVVdRenusQzOWRAjRnxdqqjpWna946gY0eHb3e4DQFk
GUH2f7xaQv5GW8KQ5hvn1D7XqAHLZ821GWuXxPEdhUkZwYrwPpTMvxMqA7GVK8Sg
znlql5Qg1NBlvI5Z00w68UK/AEU+MDLvhOBMMU4VegjBAjz9BECZKGMx921S34KA
QvWxzYzhrt9F4ML4j1gd607UPPMjZt+dX3gHjRFKdd6T5BtitDwm4RKlgPyXUERn
kLJR+450ORevIrMXB/R+47KHA5hCHZ8VJt9g/oSW/zo+a1bNbDhbv6App7T7cmaY
YNW3WxFCKlUZX4gRRJEQDzcW3OSNrkIT1muG1KazSfa9JGhH27KezkZUjbOtVk+V
08J6A1/NLdjuBlAYu/LJqCueccn5V/b3MyFoA2BCWxPqRl7XyZeUzS9UBBjfvJbn
GI8VjqcPDEARZC+87DlL
=UQqd
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
