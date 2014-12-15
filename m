Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaLOQSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:18:01 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:58282 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaLOQSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:18:00 -0500
Message-ID: <548F09B6.6010202@linaro.org>
Date: Mon, 15 Dec 2014 17:17:58 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Barry Song <baohua@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: sirf: Remove unused variable
References: <1418659160-2115-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1418659160-2115-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 04:59 PM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> Commit ef89af1f4380 ("clocksource: sirf: Remove hard-coded clock rate")
> removes all uses of the timer_div variable. Since the variable is no
> longer used it should be removed.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---

Applied to my tree. Thanks!

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

