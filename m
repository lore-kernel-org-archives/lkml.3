Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3KTVQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:16:21 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65463 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3KTVQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:16:17 -0500
Message-ID: <528D26A4.4010600@linaro.org>
Date: Wed, 20 Nov 2013 22:16:20 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com,
        olof@lixom.net, sudeep.karkadanagesha@arm.com
Subject: Re: [PATCH] drivers: clocksource: Hide arm_arch_timer eventstream
 Kconfig on non-ARM
References: <20131120192100.GA11723@amd.pavel.ucw.cz> <1384977723-32344-1-git-send-email-sboyd@codeaurora.org> <20131120210931.GA1782@amd.pavel.ucw.cz>
In-Reply-To: <20131120210931.GA1782@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 10:09 PM, Pavel Machek wrote:
> On Wed 2013-11-20 12:02:03, Stephen Boyd wrote:
>> Pavel Machek reports that this config is exposed on x86 where the
>> ARM architected timers aren't even present. Make it depend on the
>> ARM architected timers being selected so that non-ARM builds
>> aren't asked about it.
>>
>> Reported-by: Pavel Machek <pavel@ucw.cz>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
>
> Thanks!

Applied to my tree as a 3.13 fix.

Thanks Stephen and Pavel !

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

