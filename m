Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaIQFZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 01:25:53 -0400
Received: from mail-bn1on0062.outbound.protection.outlook.com ([157.56.110.62]:4893
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbaIQFZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 01:25:51 -0400
Date: Wed, 17 Sep 2014 07:25:38 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: zynq: DT: Fix GEM register area size
References: <1410880118-3494-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1410880118-3494-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="ESTdmtD3a2MFV6gPfPgvbaeuiGDLSTAQr"
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20950.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <c52d905f-06e1-41a5-b79d-42c512f0ac27@BL2FFO11FD035.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(479174003)(24454002)(164054003)(199003)(189002)(377454003)(51704005)(99396002)(1496007)(568964001)(76176999)(92726001)(85852003)(19580405001)(50986999)(71186001)(86362001)(70736001)(83322001)(65956001)(31696002)(90102001)(65806001)(79102003)(87936001)(77982003)(95666004)(31966008)(46102003)(74662003)(107046002)(104016003)(19580395003)(21056001)(74316001)(64126003)(20776003)(81342003)(92566001)(44976005)(106466001)(85306004)(512944002)(81542003)(74502003)(54356999)(83506001)(76482002)(84326002)(83072002)(80022003)(64706001)(6806004)(4396001)(65826006)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB027;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ESTdmtD3a2MFV6gPfPgvbaeuiGDLSTAQr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/16/2014 05:08 PM, Soren Brinkmann wrote:
> The size of the GEM's register area is only 0x1000 bytes.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-=
7000.dtsi
> index 6cc83d4c6c76..3eb12f25e669 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -190,7 +190,7 @@
> =20
>  		gem0: ethernet@e000b000 {
>  			compatible =3D "cdns,gem";
> -			reg =3D <0xe000b000 0x4000>;
> +			reg =3D <0xe000b000 0x1000>;
>  			status =3D "disabled";
>  			interrupts =3D <0 22 4>;
>  			clocks =3D <&clkc 30>, <&clkc 30>, <&clkc 13>;
> @@ -199,7 +199,7 @@
> =20
>  		gem1: ethernet@e000c000 {
>  			compatible =3D "cdns,gem";
> -			reg =3D <0xe000c000 0x4000>;
> +			reg =3D <0xe000c000 0x1000>;
>  			status =3D "disabled";
>  			interrupts =3D <0 45 4>;
>  			clocks =3D <&clkc 31>, <&clkc 31>, <&clkc 14>;
>=20

Applied.

Thanks,
Michal


--ESTdmtD3a2MFV6gPfPgvbaeuiGDLSTAQr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQZG1IACgkQykllyylKDCFh7gCdHCCO/jlu8XvQpvbqXDx3wGVN
fT4Aniomht/A/AdDAHpZx4rJwXy2DOHk
=7eGI
-----END PGP SIGNATURE-----

--ESTdmtD3a2MFV6gPfPgvbaeuiGDLSTAQr--
