Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaFGSVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 14:21:24 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:34075
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753016AbaFGSVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 14:21:22 -0400
Date: Sat, 7 Jun 2014 20:20:39 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: multi_v7_defconfig: Enable XADC driver
References: <1401984324-6075-1-git-send-email-soren.brinkmann@xilinx.com>
 <1401984324-6075-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1401984324-6075-2-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <2c2bb5df-5e2f-415a-9bdf-b6837ba4dd6d@BN1AFFO11FD014.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(164054003)(24454002)(377454003)(479174003)(51704005)(189002)(199002)(65956001)(21056001)(83506001)(54356999)(31966008)(77096999)(74502001)(92726001)(92566001)(83072002)(102836001)(76176999)(50986999)(85852003)(87936001)(31696002)(80022001)(64126003)(86362001)(1496006)(81342001)(83322001)(46102001)(4396001)(44976005)(19580405001)(19580395003)(81542001)(70736001)(6806004)(76482001)(20776003)(64706001)(77982001)(47776003)(99396002)(104016001)(74316001)(33646001)(23756003)(79102001)(50466002)(65826006);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB050;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0235CBE7D0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 06:05 PM, Soren Brinkmann wrote:
> The Xilinx A/D Converter is found in Xilinx devices including Zynq.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index e2d62048e198..2d1039d8c7f1 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -360,6 +360,7 @@ CONFIG_TEGRA_IOMMU_GART=y
>  CONFIG_TEGRA_IOMMU_SMMU=y
>  CONFIG_MEMORY=y
>  CONFIG_IIO=y
> +CONFIG_XILINX_XADC=y
>  CONFIG_AK8975=y
>  CONFIG_PWM=y
>  CONFIG_PWM_TEGRA=y
> 

Olof, Arnd: Are you going to take this patch directly to your tree?
I will add 1/2 to my zynq/dt branch.

Thanks,
Michal

