Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3JCObF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:31:05 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42723 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3JCObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:31:03 -0400
Message-ID: <524D7FA6.9050402@linaro.org>
Date: Thu, 03 Oct 2013 16:31:02 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ARM: at91/tc/clocksource: various robustness improvements
References: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 02:34 PM, Boris BREZILLON wrote:
> Hello,
>
> This series include several improvements regarding the at91 tc clocksource
> driver:
>   - use clk_prepare/unprepare_enable/disable functions instead of the
>     clk_enable/disable functions to prepare the transition to the common clk
>     framework
>   - check several function return values instead of considering these functions
>     always suceed.
>   - remove the deprecated IRQF_DISABLED flag
>
> Best Regards,
>
> Boris
>
> Boris BREZILLON (3):
>    ARM: at91/tc/clocksource: replace clk_enable/disable with
>      clk_prepare_enable/disable_unprepare
>    ARM: at91/tc/clocksource: improve driver robustness
>    ARM: at91/tc/clocksource: remove IRQF_DISABLED
>
>   drivers/clocksource/tcb_clksrc.c |   61 +++++++++++++++++++++++++++++++-------
>   1 file changed, 50 insertions(+), 11 deletions(-)
>

Applied to my tree for 3.13 with the subsystem name and first letter 
capitalized fixed:

clocksource: tcb_clksrc: [A-Z]*

Thanks !
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

