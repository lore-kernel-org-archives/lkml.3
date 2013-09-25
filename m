Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3IYPKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:10:25 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:39261 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab3IYPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:10:23 -0400
Message-ID: <5242FCDA.5020100@linaro.org>
Date: Wed, 25 Sep 2013 17:10:18 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Preeti Murthy <preeti.lkml@gmail.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] clockchips: Add FEAT_PERCPU clockevent flag
References: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com> <1379530118-22813-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1379530118-22813-2-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:48 PM, Soren Brinkmann wrote:
> Add the flag CLOCK_EVT_FEAT_PERCPU which is supposed to be set for per
> cpu clockevent devices.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>  include/linux/clockchips.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index 0857922..493aa02 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -60,6 +60,7 @@ enum clock_event_mode {
>   * Core shall set the interrupt affinity dynamically in broadcast mode
>   */
>  #define CLOCK_EVT_FEAT_DYNIRQ		0x000020
> +#define CLOCK_EVT_FEAT_PERCPU		0x000040
>  
>  /**
>   * struct clock_event_device - clock event device descriptor
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

