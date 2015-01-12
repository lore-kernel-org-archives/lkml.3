Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbbALHv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:51:28 -0500
Received: from mail-bn1bon0078.outbound.protection.outlook.com ([157.56.111.78]:6336
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750964AbbALHvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:51:25 -0500
Date: Mon, 12 Jan 2015 08:35:53 +0100
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
Subject: Re: [PATCH v4 5/7] ARM: zynq: Enable pinctrl
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
	<1420818231-13451-6-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdam4x-cWjrDuWS-0oDD3eGq1_pD3bK6xWEffiOipfBcOg@mail.gmail.com>
In-Reply-To: <CACRpkdam4x-cWjrDuWS-0oDD3eGq1_pD3bK6xWEffiOipfBcOg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21242.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <b03b673497694585802f77a4e40fd80b@BN1BFFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(164054003)(189002)(377454003)(199003)(479174004)(77156002)(2950100001)(46102003)(92726002)(47776003)(64706001)(65956001)(50466002)(87936001)(64126003)(50986999)(33646002)(92566002)(54356999)(74316001)(76176999)(83506001)(19580405001)(104016003)(77096005)(86362001)(6806004)(108616004)(19580395003)(106466001)(23676002)(129583001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB065;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB065;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1BFFO11HUB065;
X-Forefront-PRVS: 0454444834
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB065;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 07:36:10.6386
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1BFFO11HUB065
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 10:36 PM, Linus Walleij wrote:
> On Fri, Jan 9, 2015 at 4:43 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
>> Select pinctrl and the Zynq pinctrl driver.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> Tested-by: Andreas Färber <afaerber@suse.de>
>> ---
>> Changes since RFC v2:
>>  - separate mach-zynq changes in their own patch
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Since we're only selecting some symbols and these will appear
> in the merge window this can be applied orthogonally in the Zynq
> tree target for ARM SoC.
> 

Applied to zynq/soc.

Thanks,
Michal

