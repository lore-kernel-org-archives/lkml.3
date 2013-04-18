Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3DRJLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:11:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45055 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3DRJLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:11:11 -0400
Message-ID: <516FB8AC.6070102@linaro.org>
Date: Thu, 18 Apr 2013 11:11:08 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 1/2] intel_idle: additional Haswell CPU-id
References: <1366238537-14443-1-git-send-email-lenb@kernel.org> <0b15841b0bbbde75134a777c543dc51fe6187108.1366238380.git.len.brown@intel.com>
In-Reply-To: <0b15841b0bbbde75134a777c543dc51fe6187108.1366238380.git.len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 12:42 AM, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> There is an additional HSW CPU-id, 0x46,
> which has C-states exactly like CPU-id 0x45.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/idle/intel_idle.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 5d66750..1a38dd7 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -465,6 +465,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
>  	ICPU(0x3c, idle_cpu_hsw),
>  	ICPU(0x3f, idle_cpu_hsw),
>  	ICPU(0x45, idle_cpu_hsw),
> +	ICPU(0x46, idle_cpu_hsw),
>  	{}
>  };
>  MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);

Hi Len,

I jump on the opportunity to remind you, we are waiting for your
ack/nack for the patch:

http://permalink.gmane.org/gmane.linux.ports.tegra/10422

Thanks
  -- Daniel



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

