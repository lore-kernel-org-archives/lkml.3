Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaHUImu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:42:50 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:11386
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753806AbaHUIms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:42:48 -0400
Date: Thu, 21 Aug 2014 10:42:37 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] ARM: zynq: DT: Fix Ethernet phy modes
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="meCTC0GEiCeAGG3Pll6VifOgPRkHWi5Of"
X-RCIS-Action: ALLOW
Message-ID: <9d406f69-6022-4e61-84df-20eee5d9cd1b@BL2FFO11FD024.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(199003)(377454003)(479174003)(189002)(51704005)(83322001)(74502001)(92566001)(46102001)(19580405001)(19580395003)(95666004)(76176999)(44976005)(71186001)(81342001)(4396001)(575784001)(102836001)(74316001)(83072002)(81542001)(92726001)(85852003)(70736001)(86362001)(87936001)(85306004)(50986999)(104016003)(54356999)(1496007)(99396002)(6806004)(65956001)(83506001)(80022001)(74662001)(20776003)(84326002)(568964001)(64706001)(77982001)(107046002)(106466001)(31696002)(21056001)(76482001)(64126003)(31966008)(79102001)(512944002)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB039;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--meCTC0GEiCeAGG3Pll6VifOgPRkHWi5Of
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/20/2014 05:56 PM, Soren Brinkmann wrote:
> The used PHYs should be qualified as 'rgmii-id' instead of just 'rgmii'=
=2E
> For the Zed board this seems to make a difference between working and
> broken Ethernet.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-zc702.dts | 2 +-
>  arch/arm/boot/dts/zynq-zc706.dts | 2 +-
>  arch/arm/boot/dts/zynq-zed.dts   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-=
zc702.dts
> index 835c3089c61c..30bcfe20f0bc 100644
> --- a/arch/arm/boot/dts/zynq-zc702.dts
> +++ b/arch/arm/boot/dts/zynq-zc702.dts
> @@ -35,7 +35,7 @@
> =20
>  &gem0 {
>  	status =3D "okay";
> -	phy-mode =3D "rgmii";
> +	phy-mode =3D "rgmii-id";
>  };
> =20
>  &i2c0 {
> diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-=
zc706.dts
> index 4cc9913078cd..3d9cb023e158 100644
> --- a/arch/arm/boot/dts/zynq-zc706.dts
> +++ b/arch/arm/boot/dts/zynq-zc706.dts
> @@ -32,7 +32,7 @@
> =20
>  &gem0 {
>  	status =3D "okay";
> -	phy-mode =3D "rgmii";
> +	phy-mode =3D "rgmii-id";
>  };
> =20
>  &i2c0 {
> diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-ze=
d.dts
> index 82d7ef1a9a9c..42deb1b7dbc8 100644
> --- a/arch/arm/boot/dts/zynq-zed.dts
> +++ b/arch/arm/boot/dts/zynq-zed.dts
> @@ -32,7 +32,7 @@
> =20
>  &gem0 {
>  	status =3D "okay";
> -	phy-mode =3D "rgmii";
> +	phy-mode =3D "rgmii-id";
>  };
> =20
>  &sdhci0 {
>=20

Applied.

M



--meCTC0GEiCeAGG3Pll6VifOgPRkHWi5Of
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlP1sP0ACgkQykllyylKDCEVFwCfewhmCF5o3PzWZaObGPDBCGJD
REAAn3wq/tDiPGpfgBKSb26keh5jMT39
=4SmW
-----END PGP SIGNATURE-----

--meCTC0GEiCeAGG3Pll6VifOgPRkHWi5Of--
