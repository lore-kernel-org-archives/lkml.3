Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaHUInG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:43:06 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:26313
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753627AbaHUInC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:43:02 -0400
Date: Thu, 21 Aug 2014 10:42:52 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/3] ARM: zynq: DT: Move size/address properties to dtsi
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408550219-19825-2-git-send-email-soren.brinkmann@xilinx.com>
 <53F4C615.9060908@suse.de>
In-Reply-To: <53F4C615.9060908@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="5FaQuXaMtfLtwmoNnsjfE7VhggI2N7NPf"
X-RCIS-Action: ALLOW
Message-ID: <19edc7a7-15e8-486f-87da-04c7625b661a@BL2FFO11FD024.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(199003)(377454003)(479174003)(189002)(164054003)(51704005)(83322001)(74502001)(92566001)(46102001)(19580405001)(19580395003)(95666004)(76176999)(44976005)(71186001)(81342001)(4396001)(102836001)(74316001)(83072002)(81542001)(92726001)(85852003)(70736001)(86362001)(87936001)(85306004)(50986999)(104016003)(54356999)(1496007)(99396002)(6806004)(65956001)(83506001)(80022001)(74662001)(20776003)(84326002)(568964001)(64706001)(77982001)(107046002)(512874002)(106466001)(31696002)(21056001)(76482001)(64126003)(31966008)(79102001)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB039;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5FaQuXaMtfLtwmoNnsjfE7VhggI2N7NPf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/20/2014 06:00 PM, Andreas F=C3=A4rber wrote:
> Am 20.08.2014 17:56, schrieb Soren Brinkmann:
>> Move the GEM's size and address cells properties to the common
>> dtsi file.
>>
>> Cc: Andreas F=C3=A4rber <afaerber@suse.de>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>>  arch/arm/boot/dts/zynq-7000.dtsi      | 4 ++++
>>  arch/arm/boot/dts/zynq-parallella.dts | 2 --
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> Reviewed-by: Andreas F=C3=A4rber <afaerber@suse.de>

Applied.

Thanks,
Michal



--5FaQuXaMtfLtwmoNnsjfE7VhggI2N7NPf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlP1sQwACgkQykllyylKDCFT5wCfRlxMDuk+bvPQryPdOiSbYMFQ
QFgAni0blUUknfS1F0fDeXZqcGtbVFyn
=x7T+
-----END PGP SIGNATURE-----

--5FaQuXaMtfLtwmoNnsjfE7VhggI2N7NPf--
