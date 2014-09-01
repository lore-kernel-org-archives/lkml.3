Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaIALIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:08:47 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62715 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaIALIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:08:44 -0400
Message-ID: <540453B8.90403@monstr.eu>
Date: Mon, 01 Sep 2014 13:08:40 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: Ezra Savard <ezras@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Ezra Savard <ezra.savard@xilinx.com>
Subject: Re: [PATCH v2] ARM: zynq: DT: Add LEDs to zc702 DT
References: <1409323117-21711-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1409323117-21711-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="b4jQF8svN7fMfSR2aV3PhEiDVcFaQs3tW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b4jQF8svN7fMfSR2aV3PhEiDVcFaQs3tW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/29/2014 04:38 PM, Soren Brinkmann wrote:
> From: Ezra Savard <ezra.savard@xilinx.com>
>=20
> Adds LEDs to the zc702 devicetree for use with the leds-gpio driver.
>=20
> Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
> Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> v2:
>  - fix node names
> ---
>  arch/arm/boot/dts/zynq-zc702.dts | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-=
zc702.dts
> index 835c3089c61c..b29e0f97e764 100644
> --- a/arch/arm/boot/dts/zynq-zc702.dts
> +++ b/arch/arm/boot/dts/zynq-zc702.dts
> @@ -27,6 +27,15 @@
>  		bootargs =3D "console=3DttyPS0,115200 earlyprintk";
>  	};
> =20
> +	leds {
> +		compatible =3D "gpio-leds";
> +
> +		ds23 {
> +			label =3D "ds23";
> +			gpios =3D <&gpio0 10 0>;
> +			linux,default-trigger =3D "heartbeat";
> +		};
> +	};
>  };
> =20
>  &can0 {
>=20

Applied.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--b4jQF8svN7fMfSR2aV3PhEiDVcFaQs3tW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQEU7gACgkQykllyylKDCGRUgCfYQc93eQKjc3In6mtW9oA2ia4
dBIAoIn1Cy1bWBsmQHwaz3bfbjlylDKN
=OOof
-----END PGP SIGNATURE-----

--b4jQF8svN7fMfSR2aV3PhEiDVcFaQs3tW--
