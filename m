Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaG3L16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:27:58 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:49523 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaG3L14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:27:56 -0400
Message-ID: <53D8D6B7.5030309@monstr.eu>
Date: Wed, 30 Jul 2014 13:27:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org
CC: Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: zynq: DT: Clarify Xilinx Zynq platform
References: <7153c8eded88751e7637f08f2bfe9cb6a65036e7.1406275971.git.michal.simek@xilinx.com>
In-Reply-To: <7153c8eded88751e7637f08f2bfe9cb6a65036e7.1406275971.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="sKBqej2cRaaaxJfeKToDFCHRoP5FLXMek"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sKBqej2cRaaaxJfeKToDFCHRoP5FLXMek
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 10:15 AM, Michal Simek wrote:
> ep107 was emulation platform and compatible string
> have been changed long time ago.
>=20
> "ARM: zynq: dts: split up device tree"
> (sha1: e06f1a9ed7ebff170ba05d2606d079fb36c6a52d)
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>=20
>  Documentation/devicetree/bindings/arm/xilinx.txt | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/arm/xilinx.txt b/Documen=
tation/devicetree/bindings/arm/xilinx.txt
> index 6f1ed830b4f7..1f7995357888 100644
> --- a/Documentation/devicetree/bindings/arm/xilinx.txt
> +++ b/Documentation/devicetree/bindings/arm/xilinx.txt
> @@ -1,7 +1,7 @@
> -Xilinx Zynq EP107 Emulation Platform board
> +Xilinx Zynq Platforms Device Tree Bindings
>=20
> -This board is an emulation platform for the Zynq product which is
> -based on an ARM Cortex A9 processor.
> +Boards with Zynq-7000 SOC based on an ARM Cortex A9 processor
> +shall have the following properties.
>=20
>  Required root node properties:
> -    - compatible =3D "xlnx,zynq-ep107";
> +    - compatible =3D "xlnx,zynq-7000";
> --
> 1.8.2.3
>=20

Applied to zynq/dt.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--sKBqej2cRaaaxJfeKToDFCHRoP5FLXMek
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPY1rcACgkQykllyylKDCGv0QCcDjDiQ2fW9IQ4pjQaPn5cg4kF
0DUAn2PZe1ZPBvbkR6FPtzJDclfAKEnL
=1bLc
-----END PGP SIGNATURE-----

--sKBqej2cRaaaxJfeKToDFCHRoP5FLXMek--
