Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaHUIl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:41:56 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:43461
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753929AbaHUIlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:41:50 -0400
Date: Thu, 21 Aug 2014 10:41:39 +0200
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
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="fElvA5BxDOSshuQRRn6I8hh453RfkE42V"
X-RCIS-Action: ALLOW
Message-ID: <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(24454002)(377454003)(479174003)(189002)(164054003)(51704005)(21056001)(512944002)(1496007)(568964001)(76482001)(74316001)(106466001)(107046002)(104016003)(95666004)(33646002)(85306004)(54356999)(83506001)(102836001)(19580395003)(50986999)(31696002)(92566001)(84326002)(99396002)(31966008)(76176999)(74502001)(74662001)(85852003)(64126003)(575784001)(86362001)(83072002)(92726001)(77982001)(6806004)(64706001)(79102001)(87936001)(20776003)(71186001)(81342001)(46102001)(83322001)(70736001)(19580405001)(44976005)(65956001)(4396001)(80022001)(81542001)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB015;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fElvA5BxDOSshuQRRn6I8hh453RfkE42V
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/20/2014 05:56 PM, Soren Brinkmann wrote:
> Add missing Ethernet phys to Zynq DTs.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-zc702.dts | 6 ++++++
>  arch/arm/boot/dts/zynq-zc706.dts | 6 ++++++
>  arch/arm/boot/dts/zynq-zed.dts   | 6 ++++++
>  3 files changed, 18 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-=
zc702.dts
> index 30bcfe20f0bc..fa810505ab8f 100644
> --- a/arch/arm/boot/dts/zynq-zc702.dts
> +++ b/arch/arm/boot/dts/zynq-zc702.dts
> @@ -36,6 +36,12 @@
>  &gem0 {
>  	status =3D "okay";
>  	phy-mode =3D "rgmii-id";
> +	phy-handle =3D <&ethernet_phy>;
> +
> +	ethernet_phy: ethernet-phy@7 {
> +		compatible =3D "marvell,88e1116r", "ethernet-phy-ieee802.3-c22";

c22 is completely unused by the kernel and also c22 is default option any=
way.
Any advantage to have c22 specified here?

Thanks,
Michal


--fElvA5BxDOSshuQRRn6I8hh453RfkE42V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlP1sMMACgkQykllyylKDCF3IACfd/zsWcNWPUnjV+zg+J+/VNur
YFAAn33FvNW/ccOeahyZOOaNyIxENRQl
=OvCF
-----END PGP SIGNATURE-----

--fElvA5BxDOSshuQRRn6I8hh453RfkE42V--
