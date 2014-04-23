Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaDWG31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:29:27 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39262 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaDWG3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:29:21 -0400
Message-ID: <53575DBA.9070704@monstr.eu>
Date: Wed, 23 Apr 2014 08:29:14 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: Re: [RESEND PATCH v3 8/9] tty: cadence: Document DT binding
References: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com> <1396657425-31029-8-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1396657425-31029-8-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="B9e8ReJIVR2tKgi268NO71SxUBnKBFuDJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--B9e8ReJIVR2tKgi268NO71SxUBnKBFuDJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/05/2014 02:23 AM, Soren Brinkmann wrote:
> Add binding documentation for the Cadence UART.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> Acked-by: Rob Herring <robh@kernel.org>
> Tested-by: Michal Simek <michal.simek@xilinx.com>
> ---
>=20
> Changes in v3: None
> Changes in v2: None
>=20
>  .../devicetree/bindings/serial/cdns,uart.txt         | 20 ++++++++++++=
++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/cdns,uart.=
txt
>=20
> diff --git a/Documentation/devicetree/bindings/serial/cdns,uart.txt b/D=
ocumentation/devicetree/bindings/serial/cdns,uart.txt
> new file mode 100644
> index 000000000000..a3eb154c32ca
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/cdns,uart.txt
> @@ -0,0 +1,20 @@
> +Binding for Cadence UART Controller
> +
> +Required properties:
> +- compatible : should be "cdns,uart-r1p8", or "xlnx,xuartps"
> +- reg: Should contain UART controller registers location and length.
> +- interrupts: Should contain UART controller interrupts.
> +- clocks: Must contain phandles to the UART clocks
> +  See ../clocks/clock-bindings.txt for details.
> +- clock-names: Tuple to identify input clocks, must contain "uart_clk"=
 and "pclk"
> +  See ../clocks/clock-bindings.txt for details.
> +
> +
> +Example:
> +	uart@e0000000 {
> +		compatible =3D "cdns,uart-r1p8";
> +		clocks =3D <&clkc 23>, <&clkc 40>;
> +		clock-names =3D "uart_clk", "pclk";
> +		reg =3D <0xE0000000 0x1000>;
> +		interrupts =3D <0 27 4>;
> +	};
>=20

Applied to zynq/dt2 branch.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--B9e8ReJIVR2tKgi268NO71SxUBnKBFuDJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXXboACgkQykllyylKDCHGQgCbBXPncOPJ4uZXqZCWVlwCclpy
6XYAoJcwcRXtlGohhciU6B07VH+No9aC
=utSw
-----END PGP SIGNATURE-----

--B9e8ReJIVR2tKgi268NO71SxUBnKBFuDJ--
