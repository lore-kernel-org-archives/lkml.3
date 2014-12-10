Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaLJJmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:42:07 -0500
Received: from mail-bn1on0075.outbound.protection.outlook.com ([157.56.110.75]:36384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750803AbaLJJmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:42:01 -0500
Date: Wed, 10 Dec 2014 10:41:42 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <atull@opensource.altera.com>, <gregkh@linuxfoundation.org>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 3/6] ARM: socfpga: defconfig: enable fpga manager
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
 <1418156090-23578-4-git-send-email-atull@opensource.altera.com>
In-Reply-To: <1418156090-23578-4-git-send-email-atull@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21164.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <cec3b3d65e864b39899f3cbf17a09dc2@BN1BFFO11FD035.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(377454003)(164054003)(479174003)(189002)(24454002)(199003)(87936001)(83506001)(64706001)(6806004)(92726002)(77096005)(120916001)(47776003)(99396003)(62966003)(77156002)(31966008)(20776003)(107046002)(21056001)(2201001)(65956001)(86362001)(92566001)(106466001)(65806001)(4396001)(108616004)(104016003)(33646002)(23746002)(54356999)(19580395003)(76176999)(46102003)(50466002)(64126003)(74316001)(50986999)(19580405001)(65826006)(107986001)(24736002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB051;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB051;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB051;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB051;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 12/09/2014 09:14 PM, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Enable FPGA manager for Altera socfpga.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
>  arch/arm/configs/socfpga_defconfig |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/configs/socfpga_defconfig b/arch/arm/configs/socfpga_defconfig
> index a2956c3..2740057 100644
> --- a/arch/arm/configs/socfpga_defconfig
> +++ b/arch/arm/configs/socfpga_defconfig
> @@ -86,6 +86,10 @@ CONFIG_USB_DWC2=y
>  CONFIG_USB_DWC2_HOST=y
>  CONFIG_MMC=y
>  CONFIG_MMC_DW=y
> +CONFIG_STAGING=y
> +CONFIG_FPGA=y
> +CONFIG_FPGA_MGR_SYSFS=y
> +CONFIG_FPGA_MGR_ALTERA=y
>  CONFIG_EXT2_FS=y
>  CONFIG_EXT2_FS_XATTR=y
>  CONFIG_EXT2_FS_POSIX_ACL=y
> 

This should the last patch in this series because you are changing Kconfig
in 5/6 and 6/6.

Thanks,
Michal
