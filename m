Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaDVLMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:12:16 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47881 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaDVLMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:12:06 -0400
Message-ID: <53564E80.1050006@linaro.org>
Date: Tue, 22 Apr 2014 13:12:00 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: lorenzo.pieralisi@arm.com, rjw@rjwysocki.net, kgene.kim@samsung.com,
        Chander Kashyap <k.chander@samsung.org>
Subject: Re: [PATCH 2/4] driver: cpuidle: cpuidle-big-little: init driver
 for Exynos5420
References: <1398080958-21677-1-git-send-email-chander.kashyap@linaro.org> <1398080958-21677-3-git-send-email-chander.kashyap@linaro.org>
In-Reply-To: <1398080958-21677-3-git-send-email-chander.kashyap@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 01:49 PM, Chander Kashyap wrote:
> Add "samsung,exynos5420" compatible string to initialize generic
> big-little cpuidle driver for Exynos5420.
>
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Chander Kashyap <k.chander@samsung.org>
> ---
>   drivers/cpuidle/cpuidle-big_little.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
> index b45fc62..d0fac53 100644
> --- a/drivers/cpuidle/cpuidle-big_little.c
> +++ b/drivers/cpuidle/cpuidle-big_little.c
> @@ -170,7 +170,8 @@ static int __init bl_idle_init(void)
>   	/*
>   	 * Initialize the driver just for a compliant set of machines
>   	 */
> -	if (!of_machine_is_compatible("arm,vexpress,v2p-ca15_a7"))
> +	if (!of_machine_is_compatible("arm,vexpress,v2p-ca15_a7") &&
> +		(!of_machine_is_compatible("samsung,exynos5420")))
>   		return -ENODEV;
>   	/*
>   	 * For now the differentiation between little and big cores

BTW, are the latencies the same than the TC2 ?


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

