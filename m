Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbbALH2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:28:02 -0500
Received: from mail-bn1bbn0100.outbound.protection.outlook.com ([157.56.111.100]:10304
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751105AbbALH17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:27:59 -0500
Date: Mon, 12 Jan 2015 08:27:33 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 6/7] ARM: zynq: DT: Add pinctrl information
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
	<1420818231-13451-7-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdZ1jfTUqfLKonJxar2Jn25+4wTF-D4XUXOszSsoJrA07w@mail.gmail.com>
In-Reply-To: <CACRpkdZ1jfTUqfLKonJxar2Jn25+4wTF-D4XUXOszSsoJrA07w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21242.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <1a749692196d406a8229d4891f3563f4@BN1BFFO11FD016.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(189002)(479174004)(377454003)(199003)(51704005)(77156002)(76176999)(54356999)(50986999)(92726002)(23676002)(92566002)(108616004)(2950100001)(19580405001)(106466001)(19580395003)(104016003)(74316001)(50466002)(6806004)(64706001)(33646002)(86362001)(77096005)(87936001)(83506001)(47776003)(64126003)(46102003)(65956001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB020;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB020;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1BFFO11HUB020;
X-Forefront-PRVS: 0454444834
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB020;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 07:27:57.0752
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1BFFO11HUB020
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 10:38 PM, Linus Walleij wrote:
> On Fri, Jan 9, 2015 at 4:43 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
>> Add pinctrl descriptions to the zc702 and zc706 device trees.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> Tested-by: Andreas Färber <afaerber@suse.de>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Beautiful and in line with how I want things to look.
> 
> Yours,
> Linus Walleij
> 

Applied to zynq/dt.

Thanks,
Michal
