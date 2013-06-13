Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab3FMTUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:20:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33623 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab3FMTUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:20:00 -0400
Message-ID: <51BA1B42.5090400@pengutronix.de>
Date: Thu, 13 Jun 2013 21:19:30 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Sachin Kamat <sachin.kamat@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [RFC: PATCH] err.h: silence warning when using IS_ERR on void
 __iomem *
References: <1371072668-19027-1-git-send-email-mkl@pengutronix.de> <CAK9yfHywxyju2TbMWTfM7GBjjj8T5SdP8sc1j=VRRPxBesUtxQ@mail.gmail.com> <20130613182447.GB32574@mithrandir>
In-Reply-To: <20130613182447.GB32574@mithrandir>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2KWKJFLFAUHARCWWMGJAJ"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2KWKJFLFAUHARCWWMGJAJ
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 06/13/2013 08:24 PM, Thierry Reding wrote:
> On Thu, Jun 13, 2013 at 10:55:17AM +0530, Sachin Kamat wrote:
>> On 13 June 2013 03:01, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>>> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()"=
)
>>> introduced devm_ioremap_resource() and encourage to check its return =
value with
>>> IS_ERR(). This however leads to the following sparse warnings, as
>>> devm_ioremap_resource() returns a void __iomem pointer:
>>>
>>> drivers/net/can/c_can/c_can_platform.c:205:32: warning: incorrect typ=
e in argument 1 (different address spaces)
>>> drivers/net/can/c_can/c_can_platform.c:205:32:    expected void const=
 *ptr
>>> drivers/net/can/c_can/c_can_platform.c:205:32:    got unsigned int [n=
oderef] [usertype] <asn:2>*raminit_ctrlreg
>>
>> CC ing Thierry who has solved this issue some time back.
>=20
> I had sent two patches, one against sparse, the other against the
> kernel, but none were picked up yet.

Can you repost them? Hope someone will pick them up.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2KWKJFLFAUHARCWWMGJAJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlG6G0IACgkQjTAFq1RaXHODKwCgkknfx6oO5BJcaBvnpeB3MsDH
z+EAnjP16n3y/6JpYH+sDP3Tmnenv5hd
=eXJA
-----END PGP SIGNATURE-----

------enig2KWKJFLFAUHARCWWMGJAJ--
