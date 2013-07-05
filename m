Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab3GEIQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 04:16:32 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49167 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab3GEIQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:16:28 -0400
Date: Fri, 5 Jul 2013 10:16:24 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: sun4i: Staticize sun4i_irq_ack()
Message-ID: <20130705081624.GI2959@lukather>
References: <1373010070.14756.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q8BnQc91gJZX4vDc"
Content-Disposition: inline
In-Reply-To: <1373010070.14756.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q8BnQc91gJZX4vDc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Axel,

On Fri, Jul 05, 2013 at 03:41:10PM +0800, Axel Lin wrote:
> sun4i_irq_ack() is only referenced in this file, so make it static.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Q8BnQc91gJZX4vDc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1oDYAAoJEBx+YmzsjxAgr7AQALZE9Na2cIz4L+yiHpjd5tLR
yF98d3bswh2etJUwqaozd0T/2g5f7Ji42qrTCDMniyR8bfF4bXPpz5L5sLUdgJgR
fru+/v3RqOhYIRj1xuXEOWWxzLQ8D0KN8yMp5G8VSjFZ2TUw4EHEzOoPQA6ZuXE0
LeIfxGEFU2Qo7+G9W5pmBw2rIt59A1msrlD35VfGm3YMHuN3W0hserwXeMnmP6u+
kIlkGifugB5W/6ExsAeOFtLrZHXPgYDOhuAa9ddFhC8QooSselOShSAPM401BiS0
j7IohUnGzliFj9oyqOVDG/dpV/zgI6UyQsphnWKAF9wP4OisjGIkRrQenjOvfe1V
FhGTIm03VFVza0HiWxMebjzdrgDwHM/4trOTo4tI0GDTPYkXeQJMzjZBjpSiNfSK
zR44h9xV5J8Ac+lLDAwvMWEtGPVywnM4aojbwWZ8ncOm+xxgXvKmuocCk/4Tskle
WAgfHpI58dwslAD/BYed/pEimfN9CR3dv8rbj3F+ZThXI2X1jOII/x6ssZ9v1WPz
VQLualzISqNFVaWLmPbIP3ePWnxkUWX062mrZP6tnXhvlefQY9JE+twSEgzKdW+T
ZrrYSotk3NYMKZS83PKfqtuDyKByea8wDo2LrqFZm0oJhB+zo43237Bt9fJKYIn2
mj0e2TthQuqS4X7MOV9y
=7ueX
-----END PGP SIGNATURE-----

--Q8BnQc91gJZX4vDc--
