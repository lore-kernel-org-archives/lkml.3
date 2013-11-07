Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3KGJZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:25:40 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:53463 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3KGJZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:25:37 -0500
Message-ID: <527B5C8E.6030102@linaro.org>
Date: Thu, 07 Nov 2013 10:25:34 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Saumya Ranjan Kuanr <saumyakuanr@gmail.com>, rjw@rjwysocki.net
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu-idle: cpuidle-ux500: fixed a coding style issue
References: <1382167729-21232-1-git-send-email-saumyakuanr@gmail.com>
In-Reply-To: <1382167729-21232-1-git-send-email-saumyakuanr@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 09:28 AM, Saumya Ranjan Kuanr wrote:
> Fixed a coding style issue
>
> Signed-off-by: Saumya Ranjan Kuanr<saumyakuanr@gmail.com>

Applied for 3.14.

Changed the subject to:

ux500: cpuidle: Fix indentation

Thanks
   -- Daniel

> ---
>   drivers/cpuidle/cpuidle-ux500.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/cpuidle-ux500.c b/drivers/cpuidle/cpuidle-ux500.c
> index e056465..746d716 100644
> --- a/drivers/cpuidle/cpuidle-ux500.c
> +++ b/drivers/cpuidle/cpuidle-ux500.c
> @@ -102,7 +102,7 @@ static struct cpuidle_driver ux500_idle_driver = {
>   			.exit_latency	  = 70,
>   			.target_residency = 260,
>   			.flags		  = CPUIDLE_FLAG_TIME_VALID |
> -			                    CPUIDLE_FLAG_TIMER_STOP,
> +						CPUIDLE_FLAG_TIMER_STOP,
>   			.name		  = "ApIdle",
>   			.desc		  = "ARM Retention",
>   		},
> --
> 1.7.9.5
>
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

