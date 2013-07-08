Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3GHGSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 02:18:12 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:4131 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878Ab3GHGSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 02:18:10 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371I1432I4015Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h947hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h1d0ch1d2eh1d3fh1dfeh1dffh19b6n1155h192ch)
Date: Mon, 8 Jul 2013 08:18:02 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@infradead.org>,
        <arm@kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH 3/8] ARM: zynq: use DT_MACHINE_START
References: <1373041417-217728-1-git-send-email-arnd@arndb.de> <1373041417-217728-4-git-send-email-arnd@arndb.de>
In-Reply-To: <1373041417-217728-4-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <00de0056-2f45-4471-9d06-0b22083de0f3@CO9EHSMHS011.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 06:23 PM, Arnd Bergmann wrote:
> The zynq platform code only supports DT based booting, so we
> should use DT_MACHINE_START rather than MACHINE_START.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Michal Simek <michal.simek@xilinx.com>
> ---
>  arch/arm/mach-zynq/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index 4130e65..5b799c2 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -101,7 +101,7 @@ static const char * const zynq_dt_match[] = {
>  	NULL
>  };
>  
> -MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
> +DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
>  	.smp		= smp_ops(zynq_smp_ops),
>  	.map_io		= zynq_map_io,
>  	.init_machine	= zynq_init_machine,
> 

No objection at all.

Acked-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal


