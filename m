Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKLHeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:34:23 -0500
Received: from [157.56.110.100] ([157.56.110.100]:15118 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752227AbaKLHeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:34:19 -0500
Message-ID: <54630D32.1000307@opensource.altera.com>
Date: Wed, 12 Nov 2014 01:33:06 -0600
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
Subject: Re: [PATCHv5 2/5] arm: socfpga: Enable OCRAM ECC on startup.
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com> <1415751263-1830-3-git-send-email-tthayer@opensource.altera.com>
In-Reply-To: <1415751263-1830-3-git-send-email-tthayer@opensource.altera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: CO2PR11CA0009.namprd11.prod.outlook.com (10.141.242.147) To
 DM2PR0301MB1199.namprd03.prod.outlook.com (25.160.217.149)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1199;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1199;
X-Forefront-PRVS: 03932714EB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(479174003)(24454002)(189002)(51704005)(377454003)(199003)(87976001)(21056001)(86362001)(87266999)(50986999)(76176999)(23756003)(33656002)(54356999)(92566001)(4396001)(92726001)(2201001)(31966008)(102836001)(99136001)(97736003)(40100003)(65816999)(77156002)(77096003)(106356001)(59896002)(105586002)(46102003)(95666004)(50466002)(107046002)(83506001)(19580405001)(66066001)(62966003)(99396003)(64126003)(65956001)(65806001)(101416001)(120916001)(47776003)(20776003)(19580395003)(80316001)(42186005)(64706001)(122386002)(921003)(1121002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1199;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1199;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0845;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/11/14, 6:14 PM, tthayer@opensource.altera.com wrote:
> From: Thor Thayer <tthayer@opensource.altera.com>
> 
> This patch enables the ECC for On-Chip RAM on machine
> startup.  The ECC has to be enabled before data is
> is stored in memory otherwise the ECC will fail on
> reads.
> 
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> ---
> v2: Split OCRAM ECC portion separately. Addition of iounmap()
> and reorganization of gen_pool_free. Remove defconfig from patch.
> 
> v3/4: No change
> 
> v5: Remove ocram.h, use io.h instead of clk-provider.h
>     Check prop in correct place. Add ECC EN defines.
> ---
>  arch/arm/mach-socfpga/Makefile  |    1 +
>  arch/arm/mach-socfpga/core.h    |    1 +
>  arch/arm/mach-socfpga/ocram.c   |   90 +++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-socfpga/socfpga.c |    9 ++++
>  4 files changed, 101 insertions(+)
>  create mode 100644 arch/arm/mach-socfpga/ocram.c
> 

Acked-by: Dinh Nguyen <dinguyen@opensource.altera.com>

