Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbaJ3LKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:10:35 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:44342 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772AbaJ3LKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:10:34 -0400
Message-ID: <54521CA6.1000802@cogentembedded.com>
Date: Thu, 30 Oct 2014 14:10:30 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>, arnd@arndb.de, f.fainelli@gmail.com,
        tglx@linutronix.de, jason@lakedaemon.net, ralf@linux-mips.org,
        lethal@linux-sh.org
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH V2 09/15] irqchip: Remove ARM dependency for bcm7120-l2
 and brcmstb-l2
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com> <1414635488-14137-10-git-send-email-cernekee@gmail.com>
In-Reply-To: <1414635488-14137-10-git-send-email-cernekee@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 5:18 AM, Kevin Cernekee wrote:

> This can compile for MIPS (or anything else) now.

> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   drivers/irqchip/Kconfig | 1 -
>   1 file changed, 1 deletion(-)

> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index b21f12f..09c79d1 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -50,7 +50,6 @@ config ATMEL_AIC5_IRQ
>
>   config BRCMSTB_L2_IRQ
>   	bool
> -	depends on ARM

    How about the following?

	depends on ARM || MIPS || COMPILE_TEST

[...]

WBR, Sergei

