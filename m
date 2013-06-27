Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3F0NSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:18:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50806 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab3F0NSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:18:47 -0400
Message-ID: <51CC3B8E.8070702@ti.com>
Date: Thu, 27 Jun 2013 08:18:06 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <vincent.stehle@freescale.com>
CC: <linux-next@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Robin Holt <holt@sgi.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, <trivial@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH linux-next] ARM: OMAP2+: fix omap4-restart compilation
References: <1372335961-31401-1-git-send-email-vincent.stehle@freescale.com>
In-Reply-To: <1372335961-31401-1-git-send-email-vincent.stehle@freescale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 07:26 AM, Vincent Stehlé wrote:
> Fix following compilation error due to missing include file:
>
>    arch/arm/mach-omap2/omap4-restart.c:21:28: warning: ‘enum reboot_mode’ declared inside parameter list [enabled by default]
>    arch/arm/mach-omap2/omap4-restart.c:21:28: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>    arch/arm/mach-omap2/omap4-restart.c:21:40: error: parameter 1 (‘mode’) has incomplete type
>    arch/arm/mach-omap2/omap4-restart.c:21:6: warning: function declaration isn’t a prototype [-Wstrict-prototypes]
>    make[1]: *** [arch/arm/mach-omap2/omap4-restart.o] Error 1
>
> Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
> Cc: Robin Holt <holt@sgi.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: trivial@kernel.org
> ---
>
>
> Hi,
>
> This fixes the build of linux-next for arch ARM, config multi_v7_defconfig, tag
> next-20130627.
>
> Best regards,
>
> V.
>
>
>   arch/arm/mach-omap2/omap4-restart.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/mach-omap2/omap4-restart.c b/arch/arm/mach-omap2/omap4-restart.c
> index 652adde..41dfd7d 100644
> --- a/arch/arm/mach-omap2/omap4-restart.c
> +++ b/arch/arm/mach-omap2/omap4-restart.c
> @@ -8,6 +8,7 @@
>    */
>
>   #include <linux/types.h>
> +#include <linux/reboot.h>
>   #include "prminst44xx.h"
>
>   /**
>
Same was covered already?
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/178209.html

-- 
Regards,
Nishanth Menon
