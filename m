Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaESORN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:17:13 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57328 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaESORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:17:12 -0400
Message-ID: <537A1272.1020206@linaro.org>
Date: Mon, 19 May 2014 16:17:22 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clocksource: qcom: Implement read_current_timer for udelay
References: <1400022060-30118-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1400022060-30118-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 01:01 AM, Stephen Boyd wrote:
> Setup the same timer used as the clocksource to be used as the
> read_current_timer implementation. This allows us to support a
> stable udelay implementation on MSMs where it's possible for the
> CPUs to scale speeds independently of one another.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied to my tree for 3.16

Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

