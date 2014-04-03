Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaDCPBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:01:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46375 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbaDCPBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:01:36 -0400
Date: Thu, 3 Apr 2014 09:59:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <michals@xilinx.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 1/2] usb: doc: udc-xilinx: Add devicetree bindings
Message-ID: <20140403145934.GE14162@saruman.home>
Reply-To: <balbi@ti.com>
References: <5a9b0116-246c-40a0-b894-3321c74648de@CH1EHSMHS007.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aPdhxNJGSeOG9wFI"
Content-Disposition: inline
In-Reply-To: <5a9b0116-246c-40a0-b894-3321c74648de@CH1EHSMHS007.ehs.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aPdhxNJGSeOG9wFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 03, 2014 at 01:05:18PM +0530, Subbaraya Sundeep Bhatta wrote:
> Add devicetree bindings for Xilinx axi udc driver.
>=20
> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
> ---
> Changes for v2:
> 	- replaced xlnx,include-dma with xlnx,has-builtin-dma
>=20
>  .../devicetree/bindings/usb/udc-xilinx.txt         |   20 ++++++++++++++=
++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/udc-xilinx.txt
>=20
> diff --git a/Documentation/devicetree/bindings/usb/udc-xilinx.txt b/Docum=
entation/devicetree/bindings/usb/udc-xilinx.txt
> new file mode 100644
> index 0000000..7c24fac
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
> @@ -0,0 +1,20 @@
> +Xilinx AXI USB2 device controller
> +
> +Required properties:
> +- compatible		: Should be "xlnx,axi-usb2-device-4.00.a"
> +- reg			: Physical base address and size of the Axi USB2
> +			  device registers map.
> +- interrupts		: Property with a value describing the interrupt
> +			  number.
> +- interrupt-parent	: Must be core interrupt controller
> +- xlnx,has-builtin-dma	: if DMA is included

isn't there a configuration register to tell you this ?

> +
> +Example:
> + 		axi-usb2-device@42e00000 {
> +                        compatible =3D "xlnx,axi-usb2-device-4.00.a";
> +                        interrupt-parent =3D <0x1>;

why isn't interrupt-parent a phandle ?

--=20
balbi

--aPdhxNJGSeOG9wFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTPXdWAAoJEIaOsuA1yqRE/FEQAKhRGDDPnt9Z7ZJlBxJl/14B
0JGF+V/kanXZNuPNhT6+0wJJbxt6lBiJr54KElev6voMFdtWPGKptpmRIJjSp+4w
EFH7U3OZTu3gTNgTKD4cDBzKSfyRfAvXG9ZWlNGnRr52Bbx32xTJHS0tp2o5Ykas
Y1w8zhmlG/8gJxyH+53+gzKYMeyfguPvmszjqA3ruU6zw2mMOJ1ywU6b6962KQeL
cHutYI2/p3t0uQ3NciXTSAe7dsFqBYM/W7+JDD1vBvDt1NRIbJmBa/wjU5NsnuGw
BK5sZJHMFja0ynCafT6CAMz4D2fTh6UgkPDUMjeip7XJwBXgS2NbP8pXaEFwOsmJ
q/s2VZCenYv3Epb9XM8qug1oVU5dNyNRkJ6QiURDdFeF55AOkfMPyPI+4e3gJAHu
tqxT3SuTIGm2jFjW5vNFZHj0wDBuLKTX5q36z6IjaB+bSFF4G/juQcU7Hmrtw3mW
rVmFZqoDlcI5m79KgOTMqDTZxDB4s7iClO1qghYj9476WH1EETOqoPkrc74wrA+S
P8DOMycJ9cgZqVvT7HWHb+Icj5zboIOIgYdvN/mdNsY9xmAMJu77BGk5CTtIP4cm
MpZqzyUaXl1uzYNd6Zez7exsDDRPispGzG1b9aDCPPjEpvSRPBaYaco6mHEC2wxa
8YbZeMEUwgfyRfuVPVSk
=rDPO
-----END PGP SIGNATURE-----

--aPdhxNJGSeOG9wFI--
