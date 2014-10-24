Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaJXGI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:08:27 -0400
Received: from mail-bn1on0095.outbound.protection.outlook.com ([157.56.110.95]:59944
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751011AbaJXGI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:08:26 -0400
Date: Fri, 24 Oct 2014 08:08:15 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] MAINTAINERS: Add myself as reviewer for Zynq
References: <1414081762-28886-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1414081762-28886-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21046.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <93a573b450ca429cad3ba42f875880d7@BL2FFO11FD051.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(164054003)(377454003)(479174003)(199003)(189002)(51704005)(65806001)(76482002)(64706001)(65956001)(54356999)(50986999)(15202345003)(21056001)(20776003)(47776003)(16601075003)(31966008)(23676002)(92566001)(86362001)(587094004)(102836001)(76176999)(87936001)(95666004)(85852003)(50466002)(104016003)(120916001)(99396003)(108616004)(46102003)(64126003)(85306004)(80022003)(4396001)(107046002)(74316001)(19580395003)(106466001)(44976005)(6806004)(83506001)(15975445006)(19580405001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB031;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB031;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 06:29 PM, Soren Brinkmann wrote:
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> v2:
>  - I removed the additional 'F' entries
> 
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0484f2c526f0..8b49eeee5a27 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1543,6 +1543,7 @@ F:	arch/arm/mach-pxa/include/mach/z2.h
>  
>  ARM/ZYNQ ARCHITECTURE
>  M:	Michal Simek <michal.simek@xilinx.com>
> +R:	Sören Brinkmann <soren.brinkmann@xilinx.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  W:	http://wiki.xilinx.com
>  T:	git git://git.xilinx.com/linux-xlnx.git
> 

Applied.
IMHO: This can go through arm-soc tree.

Thanks,
Michal
