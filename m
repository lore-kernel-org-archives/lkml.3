Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3BKIsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:48:00 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44253 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3BKIr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:47:59 -0500
Message-ID: <5118B040.9010600@linaro.org>
Date: Mon, 11 Feb 2013 09:48:00 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 10/16] cpuidle: remove vestage definition of cpuidle_state_usage.driver_data
References: <1360372100-28482-1-git-send-email-lenb@kernel.org> <fe265459a3bbcfada267f181f00b83fb02f6d5cb.1360371180.git.len.brown@intel.com>
In-Reply-To: <fe265459a3bbcfada267f181f00b83fb02f6d5cb.1360371180.git.len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2013 02:08 AM, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> This field is no longer used.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>  include/linux/cpuidle.h | 22 ----------------------
>  1 file changed, 22 deletions(-)
> 
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 24cd1037..480c14d 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -32,8 +32,6 @@ struct cpuidle_driver;
>   ****************************/
>  
>  struct cpuidle_state_usage {
> -	void		*driver_data;
> -
>  	unsigned long long	disable;
>  	unsigned long long	usage;
>  	unsigned long long	time; /* in US */
> @@ -62,26 +60,6 @@ struct cpuidle_state {
>  
>  #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
>  
> -/**
> - * cpuidle_get_statedata - retrieves private driver state data
> - * @st_usage: the state usage statistics
> - */
> -static inline void *cpuidle_get_statedata(struct cpuidle_state_usage *st_usage)
> -{
> -	return st_usage->driver_data;
> -}
> -
> -/**
> - * cpuidle_set_statedata - stores private driver state data
> - * @st_usage: the state usage statistics
> - * @data: the private data
> - */
> -static inline void
> -cpuidle_set_statedata(struct cpuidle_state_usage *st_usage, void *data)
> -{
> -	st_usage->driver_data = data;
> -}
> -
>  struct cpuidle_device {
>  	unsigned int		registered:1;
>  	unsigned int		enabled:1;
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

