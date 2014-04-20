Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161135AbaDTDY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 23:24:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37520 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161029AbaDTDYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 23:24:50 -0400
Date: Sat, 19 Apr 2014 22:21:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/8] xhci-platform: Add a new controller using xhci:
 Armada 38x
Message-ID: <20140420032159.GC26893@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com>
 <1397816563-9000-4-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
In-Reply-To: <1397816563-9000-4-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2014 at 12:22:38PM +0200, Gregory CLEMENT wrote:
> Extend the compatible string list with xhci-armada-380. It is used to
> describe xhci controller which is in the Armada 38x SoCs.
>=20
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/usb/usb-xhci.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/usb-xhci.txt b/Documen=
tation/devicetree/bindings/usb/usb-xhci.txt
> index 90f8f607d125..c49c14037afe 100644
> --- a/Documentation/devicetree/bindings/usb/usb-xhci.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-xhci.txt
> @@ -1,7 +1,8 @@
>  USB xHCI controllers
> =20
>  Required properties:
> -  - compatible: should be "generic-xhci" (deprecated: "xhci-platform").
> +  - compatible: should be on of "generic-xhci",

should be "one" of.

> +    "marvell,xhci-armada-380" (deprecated: "xhci-platform").

and this gives me a better idea, instead of using the quirk I suggested
before, match against this compatible:

	if (of_device_is_compatible(dev, "marvell,xhci-armada-380")
		xhci_marvel_mbus_init_quirk(dev);

--=20
balbi

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTUz1XAAoJEIaOsuA1yqREYIgQALVyDBue9uvhNyN1mAstkVV1
nAVviGXycW6K8GW/O95ihuRSjsHeqHMxQsWlPzylz1vaWm4mlXIQUg/wvDRESAbI
oB3i88CSOI/r+C1b9UnOcMF99oo/upyLp3zKjZKKuAbMjFUwU85UaRhHhYpnprxk
rXyGv44eCZIaYQkEtUE+6Mlu7E4KxpdxcpDX6O2AeDh19D3kfQgC63cPQe8UMRFC
y64SHcQuRcFr3d+3s32sn/DbNunIZ/+0PK+IVpCpLVyiE622mK4ME7fRAY1ribnf
BGMn0jmRQ7ESoMHP5GE1+pWsizqHQOS9umcFR724UsHFoREfDkvR362wk0okxUg5
VmVMMiQTlA3re9OnjYoWFVwrFH5yP1wo5fIDbd4wWk91V6mDus/2Ou1dK13P1xt/
lqGOhyZgVAoJubc1Ti3hwIRf8Pw9Wx6CjQ30prHAAtPc8bZSoDIqpyiaUhlkXI/c
kL0CMI5GfuTvS1JVT52Ztff/uRY5z52XXZi9pB0fEKwXvm82bbrJ623+40JOQBfr
xE4GCKPHmKQpKvrwQIwO/ozFO0TZrErHCs8y06Jj+ohZDcS8gxbnIZkPZd1Aw15v
VNvbckD7mUp/VXcyaFY15JGr70FlurTwD9Em7ZlsvIuvjytB3e8E+WhXCgXNF1Q5
Oe62gHuVQwVd7D1CBcci
=fRIf
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
