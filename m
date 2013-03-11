Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3CKJI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:08:57 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:49478 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3CKJI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:08:56 -0400
Message-ID: <513D9F23.5050705@linaro.org>
Date: Mon, 11 Mar 2013 10:08:51 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: lenb@kernel.org, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 V2] intel_idle: Removing the redundant calculating
 for dev->state_count
References: <1362674529.31506.17.camel@cliu38-desktop-build>  <1362754926.31506.42.camel@cliu38-desktop-build>  <1362755074.31506.45.camel@cliu38-desktop-build> <1362998657.31506.52.camel@cliu38-desktop-build>
In-Reply-To: <1362998657.31506.52.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 11:44 AM, Chuansheng Liu wrote:
> 
> In function intel_idle_cpu_init() and intel_idle_cpuidle_driver_init(),
> they are having the same for(;;) loop to count the ->state_count.
> 
> Although intel_idle_cpu_init() can be called at runtime CPU HOTPLUG case,
> but max_cstate can not be changed at runtime.
> 
> So the dev->state_count should be == drv->state_count, in the function
> cpuidle_register_device() has done the initialization.
> 
> Here we can clean up these pieces of code.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>




-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

