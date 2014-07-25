Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbaGYJke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:40:34 -0400
Received: from [207.46.163.237] ([207.46.163.237]:46791 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757778AbaGYJkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:40:31 -0400
Date: Fri, 25 Jul 2014 11:38:19 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>, <monstr@monstr.eu>,
        =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Harini Katakam <harinik@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-6-git-send-email-afaerber@suse.de>
 <ddb38ce5-9e31-4c94-967c-7784c7fba75c@BN1BFFO11FD028.protection.gbl>
 <53D20E5B.9070501@monstr.eu> <53D21887.2020305@suse.de>
In-Reply-To: <53D21887.2020305@suse.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="P3EDFoVLsodiaKB4S45t2vbFuD8Oj7mDl"
X-RCIS-Action: ALLOW
Message-ID: <1cf9126b-c5e4-4ae7-a294-071584857d6c@BN1AFFO11FD052.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51164003)(164054003)(24454002)(479174003)(377424004)(377454003)(199002)(189002)(51704005)(102836001)(512874002)(106466001)(86362001)(1496007)(93886003)(95666004)(104016003)(92566001)(85852003)(107046002)(83072002)(92726001)(50986999)(31696002)(83506001)(33646002)(54356999)(74316001)(76176999)(84326002)(85306003)(64126003)(87936001)(76482001)(4396001)(81342001)(568964001)(46102001)(79102001)(19580405001)(21056001)(20776003)(64706001)(71186001)(70736001)(77982001)(81542001)(65806001)(80022001)(19580395003)(74502001)(65956001)(83322001)(44976005)(99396002)(6806004)(31966008)(74662001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB020;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--P3EDFoVLsodiaKB4S45t2vbFuD8Oj7mDl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 10:42 AM, Andreas F=C3=A4rber wrote:
> Am 25.07.2014 09:59, schrieb Michal Simek:
>> On 07/25/2014 01:18 AM, S=C3=B6ren Brinkmann wrote:
>>> On Fri, 2014-07-25 at 01:00AM +0200, Andreas F=C3=A4rber wrote:
>>>> Prepare SPI0 and SPI1 while at it.
>=20
>> Patch subject is incorrect. You are adding SPI and QSPI.
>=20
> Yes, it originally added only QSPI, but I considered it a good deed to
> add SPI as well while already reading that part of the TRM. :)
>=20
>>>>
>>>> Signed-off-by: Andreas F=C3=A4rber <afaerber@suse.de> --- v2: New
>>>>
>>>> arch/arm/boot/dts/zynq-7000.dtsi      | 37
>>>> +++++++++++++++++++++++++++++++++++=20
>>>> arch/arm/boot/dts/zynq-parallella.dts |  4 ++++ 2 files
>>>> changed, 41 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi
>>>> b/arch/arm/boot/dts/zynq-7000.dtsi index 8fd826a..eed3df0
>>>> 100644 --- a/arch/arm/boot/dts/zynq-7000.dtsi +++
>>>> b/arch/arm/boot/dts/zynq-7000.dtsi @@ -122,6 +122,30 @@=20
>>>> interrupts =3D <0 50 4>; };
>>>>
>>>> +		spi0: spi@e0006000 { +			compatible =3D "xlnx,zynq-spi-r1p6";=20
>>>> +			reg =3D <0xe0006000 0x1000>; +			status =3D "disabled"; +
>>>> interrupt-parent =3D <&intc>; +			interrupts =3D <0 26 4>; +
>>>> clocks =3D <&clkc 25>, <&clkc 34>; +			clock-names =3D "ref_clk",
>>>> "pclk"; +			#address-cells =3D <1>; +			#size-cells =3D <0>; +		};=20
>>>> + +		spi1: spi@e0007000 { +			compatible =3D
>>>> "xlnx,zynq-spi-r1p6"; +			reg =3D <0xe0007000 0x1000>; +			status
>>>> =3D "disabled"; +			interrupt-parent =3D <&intc>; +			interrupts =3D=

>>>> <0 49 4>; +			clocks =3D <&clkc 26>, <&clkc 35>; +			clock-names
>>>> =3D "ref_clk", "pclk"; +			#address-cells =3D <1>; +			#size-cells
>>>> =3D <0>; +		}; +
>>> Until here things look good.
>>>
>>>> gem0: ethernet@e000b000 { compatible =3D "cdns,gem"; reg =3D
>>>> <0xe000b000 0x4000>; @@ -140,6 +164,19 @@ clock-names =3D "pclk",
>>>> "hclk", "tx_clk"; };
>>>>
>>>> +		qspi: qspi@e000d000 { +			compatible =3D
>>>> "xlnx,zynq-spi-r1p6"; +			reg =3D <0xe000d000 0x1000>; +			status
>>>> =3D "disabled"; +			interrupt-parent =3D <&intc>; +			interrupts =3D=

>>>> <0 19 4>; +			clocks =3D <&clkc 10>, <&clkc 43>; +			clock-names
>>>> =3D "ref_clk", "pclk"; +			num-cs =3D <1>; +			#address-cells =3D
>>>> <1>; +			#size-cells =3D <0>; +		}; +
>>> I'm not sure what the status of this driver is. I think QSPI is
>>> still under review on the mailing lists and I don't think we
>>> should add this yet.
>=20
>> Driver for qspi is not in the mainline yet but it doesn't mean that
>> this fragment won't work. Harini: Can you please correct me if I am
>> wrong?
>=20
> It did seem to find the flash chip (cf. parallella-next branch), but I
> didn't find a driver capable of handling its ID. The downstream tree
> was using m25p80; I tried both micron,n25q128a11 and ...a13 based on
> U-Boot output.
>=20
>> I would prefer to send two separate patches.
>=20
> Will do.
>=20
>> 1. just add SPI to zynq
>=20
> As I don't have any of the other Zynq boards, can you please advise
> whether either of them should be enabled for some board?

we don't have them enabled for any board in default configuration
that's why just adding nodes with status =3D "disabled" is fine.

Thanks,
Michal


--P3EDFoVLsodiaKB4S45t2vbFuD8Oj7mDl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPSJYsACgkQykllyylKDCET8QCgmv7LcnzTey3z3oBd9klwizIx
vZQAnRnpQDPJEZEM10QUYZeaDt3U17F8
=0FNN
-----END PGP SIGNATURE-----

--P3EDFoVLsodiaKB4S45t2vbFuD8Oj7mDl--
