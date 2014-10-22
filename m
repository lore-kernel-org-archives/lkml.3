Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaJVG3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:29:54 -0400
Received: from mail-bn1bon0067.outbound.protection.outlook.com ([157.56.111.67]:9682
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750769AbaJVG3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:29:53 -0400
Date: Wed, 22 Oct 2014 08:29:36 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] MAINTAINERS: Update Zynq maintainer record
References: <1413927103-31358-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1413927103-31358-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21042.001
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <ba5ded105f25449a8ccd35f3109ff2de@BL2FFO11FD019.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(51704005)(377454003)(479174003)(24454002)(164054003)(199003)(19580395003)(6806004)(44976005)(19580405001)(15975445006)(83506001)(87936001)(4396001)(46102003)(80022003)(85306004)(587094004)(107046002)(108616004)(106466001)(95666004)(99396003)(76482002)(120916001)(50986999)(76176999)(54356999)(92566001)(86362001)(102836001)(21056001)(31966008)(64706001)(104016003)(47776003)(20776003)(65806001)(85852003)(65956001)(74316001)(64126003)(50466002)(23676002)(15202345003)(16601075003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB060;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB060;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 037291602B
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 11:31 PM, Soren Brinkmann wrote:
>  - add myself as reviewer for Zynq
>  - add entry to cover Zynq clock drivers
>  - add entry to cover Xilinx DMA drivers
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a20df9bf8ab0..07eecdddbe8b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1543,6 +1543,7 @@ F:	arch/arm/mach-pxa/include/mach/z2.h
>  
>  ARM/ZYNQ ARCHITECTURE
>  M:	Michal Simek <michal.simek@xilinx.com>
> +R:	Sören Brinkmann <soren.brinkmann@xilinx.com>

this is fine.

>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  W:	http://wiki.xilinx.com
>  T:	git git://git.xilinx.com/linux-xlnx.git
> @@ -1552,7 +1553,9 @@ F:	drivers/cpuidle/cpuidle-zynq.c
>  F:	drivers/block/xsysace.c
>  N:	zynq
>  N:	xilinx
> +F:	drivers/clk/zynq/

this is handled by N: zynq

>  F:	drivers/clocksource/cadence_ttc_timer.c
> +F:	drivers/dma/xilinx/

ditto.

>  F:	drivers/i2c/busses/i2c-cadence.c
>  F:	drivers/mmc/host/sdhci-of-arasan.c
>  

Thanks,
Michal


