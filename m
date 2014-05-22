Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaEVMGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:06:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43029 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaEVMGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:06:00 -0400
Message-ID: <537DE835.5010703@linaro.org>
Date: Thu, 22 May 2014 14:06:13 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] clocksource: remove unnecessary OOM messages
References: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
In-Reply-To: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 10:24 AM, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message. For example,
> k.alloc and v.alloc failures use dump_stack().
>
> Jingoo Han (4):
>        clocksource: em_sti: remove unnecessary OOM messages
>        clocksource: sh_cmt: remove unnecessary OOM messages
>        clocksource: sh_mtu2: remove unnecessary OOM messages
>        clocksource: sh_tmu: remove unnecessary OOM messages
>
> ---
>   drivers/clocksource/em_sti.c  |    4 +---
>   drivers/clocksource/sh_cmt.c  |    4 +---
>   drivers/clocksource/sh_mtu2.c |    4 +---
>   drivers/clocksource/sh_tmu.c  |    4 +---
>   4 files changed, 4 insertions(+), 12 deletions(-)

Applied to my tree for 3.16 with some slight changes due to Laurent's 
changes (kmalloc -> kzalloc).

Thanks !
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

