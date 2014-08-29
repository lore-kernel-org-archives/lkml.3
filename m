Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaH2E53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 00:57:29 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:3385
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750800AbaH2E51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 00:57:27 -0400
Date: Fri, 29 Aug 2014 06:57:15 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: Ezra Savard <ezras@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Ezra Savard <ezra.savard@xilinx.com>
Subject: Re: [PATCH] ARM: zynq: DT: Add LEDs to zc702 DT
References: <1409242973-2735-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140828171536.GB4345@xsjandreislx>
In-Reply-To: <20140828171536.GB4345@xsjandreislx>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="47Ir30rTcEQf8R6Ol1DKg2pPU9u6tq70C"
X-RCIS-Action: ALLOW
Message-ID: <93dd8f20-f13a-4446-8b11-e8508fc0ebb7@BY2FFO11FD047.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(199003)(51704005)(189002)(164054003)(377454003)(377424004)(479174003)(50986999)(76176999)(80022001)(95666004)(19580405001)(65956001)(107046002)(1496007)(102836001)(512874002)(74316001)(106466001)(85306004)(104016003)(83506001)(90102001)(568964001)(31696002)(79102001)(54356999)(99396002)(31966008)(85852003)(83072002)(92566001)(81342001)(44976005)(19580395003)(20776003)(71186001)(46102001)(74662001)(64706001)(21056001)(81542001)(86362001)(65806001)(70736001)(76482001)(77982001)(92726001)(74502001)(87936001)(4396001)(83322001)(6806004)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB046;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0318501FAE
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--47Ir30rTcEQf8R6Ol1DKg2pPU9u6tq70C
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/28/2014 07:15 PM, S=C3=B6ren Brinkmann wrote:
> On Thu, 2014-08-28 at 09:22AM -0700, Soren Brinkmann wrote:
>> From: Ezra Savard <ezra.savard@xilinx.com>
>>
>> Adds LEDs to the zc702 devicetree for use with the leds-gpio driver.
>>
>> Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
>> Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>>  arch/arm/boot/dts/zynq-zc702.dts | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq=
-zc702.dts
>> index 835c3089c61c..4e9fe26b3e85 100644
>> --- a/arch/arm/boot/dts/zynq-zc702.dts
>> +++ b/arch/arm/boot/dts/zynq-zc702.dts
>> @@ -27,6 +27,16 @@
>>  		bootargs =3D "console=3DttyPS0,115200 earlyprintk";
>>  	};
>> =20
>> +	gpio-leds {
> The node name should rather be just 'leds'. That slipped through, sorry=
=2E
> Do you want a v2 for that?

yes, please send v2.

Thanks,
Michal




--47Ir30rTcEQf8R6Ol1DKg2pPU9u6tq70C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQACCsACgkQykllyylKDCHOkACfXwIuicyn/1RK5huAlGoCrjnJ
iAYAn104llAWJWyr+5PWtE9sCZLcYa9I
=xMBG
-----END PGP SIGNATURE-----

--47Ir30rTcEQf8R6Ol1DKg2pPU9u6tq70C--
