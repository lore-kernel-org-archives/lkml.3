Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3JJPaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:30:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34197 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab3JJPaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:30:09 -0400
Date: Thu, 10 Oct 2013 10:29:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <matt.porter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH 2/5] usb: gadget: s3c-hsotg: support configurable UTMI
 PHY width
Message-ID: <20131010152922.GF28375@radagast>
Reply-To: <balbi@ti.com>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
 <1381140752-312-3-git-send-email-matt.porter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TU+u6i6jrDPzmlWF"
Content-Disposition: inline
In-Reply-To: <1381140752-312-3-git-send-email-matt.porter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TU+u6i6jrDPzmlWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 07, 2013 at 06:12:29AM -0400, Matt Porter wrote:
> Extend dwc2 binding with an optional utmi phy width property.
> Enable the s3c-hsotg.c driver to use standard dwc2 binding
> and enable configuration of the UTMI phy width based on the
> property.
>=20
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> ---
>  Documentation/devicetree/bindings/staging/dwc2.txt |  4 ++++
>  drivers/usb/gadget/s3c-hsotg.c                     | 18 ++++++++++++++++=
+-
>  drivers/usb/gadget/s3c-hsotg.h                     |  1 +
>  3 files changed, 22 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt b/Documen=
tation/devicetree/bindings/staging/dwc2.txt
> index 1a1b7cf..fb6b8ee 100644
> --- a/Documentation/devicetree/bindings/staging/dwc2.txt
> +++ b/Documentation/devicetree/bindings/staging/dwc2.txt
> @@ -6,10 +6,14 @@ Required properties:
>  - reg : Should contain 1 register range (address and length)
>  - interrupts : Should contain 1 interrupt
> =20
> +Optional properties:
> +- snps,phy-utmi-width: Must contain the UTMI data width (either 8 or 16)

isn't this available in any of the configuration registers ?

>  Example:
> =20
>          usb@101c0000 {
>                  compatible =3D "ralink,rt3050-usb, snps,dwc2";
>                  reg =3D <0x101c0000 40000>;
>                  interrupts =3D <18>;
> +		snps,phy-utmi-width =3D <8>;

indentation.

--=20
balbi

--TU+u6i6jrDPzmlWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVsfSAAoJEIaOsuA1yqRELPIP/Ajde/LDQlr3ObNPEJ3yIC6L
3ZtjPtRK5d1lmIxRhTCm6y2s7ejFnRpze+wUkoVtNtsoC64CX1U3DZKUHO1jnppD
Tr26t1M3/Ya2vfK/be3+Oo4NV8fk2LAnJupWNTdSRkdpU0qB4GPqnviI+BUGLZG0
epl7C3dJKpAAvi8WETeBSRjji0foQ5OChu4xFeOOHwWkcxQyj3nnuNYCobIFYghV
vx18+1lsr9q1fuI7VB2kLP2EAPUEZ5LISXlI4kKVBuD5D6WpVuTaK5JyGoSWiiJt
83+IBUjxSMevjLLPZyDRc1BNu4gEW5GnS4+L3PkpRkMtJvCP8lZa/YBug8ZQdMo7
/lBSZi+g1RyYBsxcKAi979AsmYQZEb7AzQyufqeza37nbxvwtOEuidBgoLBWmc23
YyZQHCCkMjx8hhdbCiF9zU9J3LO7SoP3KPReUDQf//jZZkd889tb5JGSVBYpyv2/
aq7gxILRDpJxyEai0EkRU2/ZN3LV7y7kUUgdNHA6LxNrglOvIkaPCWgiRy/Znoic
fRLzpS3Y5qJatCF8F52a5l8jwKCVUVw/GElY8fqbgSEuxYveGc3HqZWoX/BJrHWq
6TWDqXijKt9dDbI5TIS31f0ZiBqChhceFBHcxSEakXM7NktBffjbaIWshaQUVn/t
CF8otXjmJ4IkSHwwMGC4
=kyS7
-----END PGP SIGNATURE-----

--TU+u6i6jrDPzmlWF--
