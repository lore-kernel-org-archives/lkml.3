Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaDWG3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:29:32 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:59157 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaDWG32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:29:28 -0400
Message-ID: <53575DC4.6080008@monstr.eu>
Date: Wed, 23 Apr 2014 08:29:24 +0200
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
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: Re: [RESEND PATCH v3 9/9] ARM: zynq: DT: Migrate UART to Cadence
 binding
References: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com> <1396657425-31029-9-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1396657425-31029-9-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ipujcCmbOhw5wbTsgMQGL1oEoJNNiIaW1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ipujcCmbOhw5wbTsgMQGL1oEoJNNiIaW1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/05/2014 02:23 AM, Soren Brinkmann wrote:
> The Zynq UART is Cadence IP and the driver has been renamed accordingly=
=2E
> Migrate the DT to use the new binding for the UART driver.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> Acked-by: Rob Herring <robh@kernel.org>
> Tested-by: Michal Simek <michal.simek@xilinx.com>
> ---
> This change depends on 'tty: xuartps: Rebrand driver as Cadence UART',
> which introduces the new clock-names.
>=20
> Changes in v3: None
> Changes in v2: None
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-=
7000.dtsi
> index 789d0bacc110..d27eb5c21831 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -73,19 +73,19 @@
>  		};
> =20
>  		uart0: uart@e0000000 {
> -			compatible =3D "xlnx,xuartps";
> +			compatible =3D "xlnx,xuartps", "cdns,uart-r1p8";
>  			status =3D "disabled";
>  			clocks =3D <&clkc 23>, <&clkc 40>;
> -			clock-names =3D "ref_clk", "aper_clk";
> +			clock-names =3D "uart_clk", "pclk";
>  			reg =3D <0xE0000000 0x1000>;
>  			interrupts =3D <0 27 4>;
>  		};
> =20
>  		uart1: uart@e0001000 {
> -			compatible =3D "xlnx,xuartps";
> +			compatible =3D "xlnx,xuartps", "cdns,uart-r1p8";
>  			status =3D "disabled";
>  			clocks =3D <&clkc 24>, <&clkc 41>;
> -			clock-names =3D "ref_clk", "aper_clk";
> +			clock-names =3D "uart_clk", "pclk";
>  			reg =3D <0xE0001000 0x1000>;
>  			interrupts =3D <0 50 4>;
>  		};
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



--ipujcCmbOhw5wbTsgMQGL1oEoJNNiIaW1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXXcQACgkQykllyylKDCHW9wCghT57+CmaEFZuaeDfMFT1ax04
e8wAn2TPCGCyUm773W0cP6xAeeCYmXn4
=Qb8/
-----END PGP SIGNATURE-----

--ipujcCmbOhw5wbTsgMQGL1oEoJNNiIaW1--
