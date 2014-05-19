Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaESOTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:19:03 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43696 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaESOTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:19:00 -0400
Message-ID: <537A12DF.2030101@linaro.org>
Date: Mon, 19 May 2014 16:19:11 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] clocksource: fix type confusion for clocksource_mmio_readX_Y
References: <1398219120-23029-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1398219120-23029-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 04:11 AM, Xiubo Li wrote:
> The types' definations are:
>     o  cycle_t       -> u64
>     o  readl_relaxed -> u32
>     o  readw_relaxed -> u16
>
> So let clocksource_mmio_readX_Ys return a cast to cycle_t, though
> this maybe look reduntant sometimes, it make sense and they will be
> more readable and less confusion...
>
> This patch clarifies the functions type and fix it.
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---

Applied to my tree for 3.16

Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

