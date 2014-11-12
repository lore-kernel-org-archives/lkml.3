Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaKLHdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:33:14 -0500
Received: from [207.46.100.98] ([207.46.100.98]:6861 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751100AbaKLHdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:33:12 -0500
Message-ID: <54630CF3.6020409@opensource.altera.com>
Date: Wed, 12 Nov 2014 01:32:03 -0600
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <tthayer@opensource.altera.com>, <bp@alien8.de>,
        <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: Re: [PATCHv5 1/5] arm: socfpga: Enable L2 Cache ECC on startup.
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com> <1415751263-1830-2-git-send-email-tthayer@opensource.altera.com>
In-Reply-To: <1415751263-1830-2-git-send-email-tthayer@opensource.altera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: CO2PR11CA0003.namprd11.prod.outlook.com (10.141.242.141) To
 BN3PR0301MB1185.namprd03.prod.outlook.com (25.160.156.147)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1185;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1185;
X-Forefront-PRVS: 03932714EB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(51704005)(24454002)(377454003)(479174003)(42186005)(64706001)(4396001)(99136001)(50466002)(33656002)(54356999)(76176999)(87266999)(65816999)(99396003)(50986999)(120916001)(87976001)(21056001)(97736003)(31966008)(122386002)(47776003)(64126003)(92726001)(86362001)(20776003)(65956001)(66066001)(92566001)(65806001)(23756003)(59896002)(95666004)(40100003)(46102003)(101416001)(80316001)(2201001)(102836001)(106356001)(19580405001)(77096003)(77156002)(105586002)(19580395003)(107046002)(83506001)(62966003)(1121002)(921003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1185;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1185;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1251;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/11/14, 6:14 PM, tthayer@opensource.altera.com wrote:
> From: Thor Thayer <tthayer@opensource.altera.com>
> 
> This patch enables the ECC for L2 cache on machine
> startup.  The ECC has to be enabled before data is
> is stored in memory otherwise the ECC will fail on
> reads.
> 
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> ---
> v2: Split OCRAM initialization into separate patch.
> 
> v3/4: No change
> 
> v5: Remove l2cache.h, use io.h instead of clk-provider.h
>     Make copyright header inclusive. Remove MAINTAINERS entry.
> ---
>  arch/arm/mach-socfpga/Makefile   |    1 +
>  arch/arm/mach-socfpga/core.h     |    2 ++
>  arch/arm/mach-socfpga/l2_cache.c |   41 ++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-socfpga/socfpga.c  |    4 +++-
>  4 files changed, 47 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/mach-socfpga/l2_cache.c
> 

Acked-by: Dinh Nguyen <dinguyen@opensource.altera.com>
