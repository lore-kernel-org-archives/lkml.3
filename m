Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3G3UKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:10:10 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43767 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756716Ab3G3UKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:10:09 -0400
Date: Tue, 30 Jul 2013 22:10:06 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-arm-kernel@lists.infradead.org, Emilio Lopez <emilio@elopez.com.ar>,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [PATCH 08/10] ARM: sun7i: DT: Add UART muxing options to the DTSI
Message-ID: <20130730201006.GD12562@lukather>
References: <1375196394-21138-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375196394-21138-9-git-send-email-maxime.ripard@free-electrons.com>
 <51F80EE9.30801@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <51F80EE9.30801@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sergei,

On Tue, Jul 30, 2013 at 11:07:21PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 07/30/2013 06:59 PM, Maxime Ripard wrote:
>=20
> >The UARTs on the A20 can be muxed to several pins. Add a few options to
> >the DTSI so that we can start using them in the boards' DT.
>=20
> >Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >---
> >  arch/arm/boot/dts/sun7i-a20.dtsi | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
>=20
> >diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-=
a20.dtsi
> >index 704fca9..9f45e8d 100644
> >--- a/arch/arm/boot/dts/sun7i-a20.dtsi
> >+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> >@@ -70,6 +70,27 @@
> >  			#address-cells =3D <1>;
> >  			#size-cells =3D <0>;
> >  			#gpio-cells =3D <3>;
> >+
> >+			uart0_pins_a: uart0@0 {
>=20
>    Why have address part of the node name if there's not "reg" property?

It allows to easily differentiate distinct pin groups for the same IP.

A second group of pin that can be muxed to uart0 would be defined as
uart0_pins_b: uart0@1.

I could have used any other construct, like uart0-0 and uart0-1, I just
find that it fits more in the usual DT constructs.

> And the preferred node name is "serial", not "uart", according to
> the ePAPR spec (http://www.power.org/resources/downloads/Power_ePAPR_APPR=
OVED_v1.0.pdf).

But only for actual serial driver right? This is a pinctrl group
declaration.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+B2eAAoJEBx+YmzsjxAgyXsP/08RQZcK7mUiLsAsmdNzcRSU
U33wHzXuSNUPBWERx6vPc//ZipN8esnBbJj60JwRhf4XA6Xny6WArvpO5rLxzRdN
xwOJ6f4WNAEYGpWLdNB9ssmy9Tw3KDCn0birRIgkmdF6Q4ghQKXfPnNq4w0eS4EZ
4in8NyZrxAeQpBVphzJcUfg//Xy/NWML751ksfmZlEcukZrxkf0YaCVemH18A19z
dS7t+taH4QeZ9PKWl7DQUnCPo5LGv5IApE6qY7LBFU9g0LxjOc7B6sXjaK7TNClh
z1vWqnBrB6pkJLttEwcOlFnWYmxnFtJd29S1Ln+rUdP0nfGab7gZ58+I2ordVGT7
BTLxlNrXJlkrdnRZ1pmfjDYP1Ns0PGLH6/fDhIg9Ex1IOh8bhO/kTzPvBCHA/anu
96NPOiYeyEYhLmM4NHrEiLUZlsv5TykY8Xd/4qOWIASiRFj7Am9LVzODEq8+29b0
yKAoUjClnTsK16k9N+rYdi4S7OgNqTlyQq3Kx+6pbsluq+F9Y9FIlfbCPHJZaTXr
7VNTzStt3gGPQvlGLXelSFhmksWK1yVVi8lOjacEZIyqKcY9mWARajU8hNaMxLqP
7zk9rLz6nmgz82VRaDBPNbdGoL39Z8x24HHWIRmUJx36J8l0vbdAlwYRNwabUGcM
HHWlwOTR3FdZUN2FjUSa
=ziIp
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--
