Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbbA1U7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:59:11 -0500
Received: from mail-bl2on0098.outbound.protection.outlook.com ([65.55.169.98]:2690
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756116AbbA1U7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:59:06 -0500
Date: Wed, 28 Jan 2015 15:22:55 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Heiko Stuebner <heiko@sntech.de>, Pawel Moll <pawel.moll@arm.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Beniamino Galvani" <b.galvani@gmail.com>,
        "ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH v4 6/7] ARM: zynq: DT: Add pinctrl information
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
 <1420818231-13451-7-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdZ1jfTUqfLKonJxar2Jn25+4wTF-D4XUXOszSsoJrA07w@mail.gmail.com>
 <1a749692196d406a8229d4891f3563f4@BN1BFFO11FD016.protection.gbl>
 <54C6D510.6090105@suse.de>
In-Reply-To: <54C6D510.6090105@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="g11hhdKa1kOVO1p0GTnEo7Gkr3KLNnS9k"
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21288.007
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <41babf16a78d4d48855d80d61262e39a@BL2FFO11FD033.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; suse.de; dkim=none (message not
 signed) header.d=none;
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(377454003)(479174004)(24454002)(51704005)(164054003)(108616004)(568964001)(83506001)(19580395003)(62966003)(77156002)(104016003)(19580405001)(84326002)(106466001)(64126003)(87936001)(512874002)(65806001)(65956001)(92726002)(92566002)(50986999)(76176999)(15975445007)(74316001)(77096005)(2950100001)(54356999)(6806004)(46102003)(86362001)(93886004)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB051;H:xir-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB051;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB051;
X-Forefront-PRVS: 047001DADA
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB051;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 14:23:20.6458
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB051
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--g11hhdKa1kOVO1p0GTnEo7Gkr3KLNnS9k
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/27/2015 01:00 AM, Andreas F=C3=A4rber wrote:
> Am 12.01.2015 um 08:27 schrieb Michal Simek:
>> On 01/11/2015 10:38 PM, Linus Walleij wrote:
>>> On Fri, Jan 9, 2015 at 4:43 PM, Soren Brinkmann
>>> <soren.brinkmann@xilinx.com> wrote:
>>>
>>>> Add pinctrl descriptions to the zc702 and zc706 device trees.
>>>>
>>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>>> Tested-by: Andreas F=C3=A4rber <afaerber@suse.de>
>>>
>>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> Beautiful and in line with how I want things to look.
>>>
>>> Yours,
>>> Linus Walleij
>>>
>>
>> Applied to zynq/dt.
>=20
> Did you maybe forget to push?
>=20
> https://github.com/Xilinx/linux-xlnx/commits/zynq/dt doesn't have it.

Ah sorry - I have pushed it now.

Thanks,
Michal



--g11hhdKa1kOVO1p0GTnEo7Gkr3KLNnS9k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlTI8L8ACgkQykllyylKDCF0DQCdHsx8Riz6BWAsBfKkzbn+Qats
QuIAoJrLL3ZvczibjyujdweDn64rBb7w
=0WFN
-----END PGP SIGNATURE-----

--g11hhdKa1kOVO1p0GTnEo7Gkr3KLNnS9k--
