Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab3CIDBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:01:08 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54751 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab3CIDBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:01:05 -0500
Message-ID: <513AA5ED.2030300@linaro.org>
Date: Sat, 09 Mar 2013 04:01:01 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: lenb@kernel.org, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] intel_idle: set the state_tables array as __initdata
 to save mem
References: <1362674529.31506.17.camel@cliu38-desktop-build>  <1362754926.31506.42.camel@cliu38-desktop-build> <1362755169.31506.47.camel@cliu38-desktop-build>
In-Reply-To: <1362755169.31506.47.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 04:06 PM, Chuansheng Liu wrote:
> 
> Currently, in intel_idle.c, there are 5 state_tables array, every
> array size is sizeof(struct cpuidle_state) * CPUIDLE_STATE_MAX.
> 
> As in intel_idle_cpuidle_driver_init(), we have copied the data into
> intel_idle_driver->state[], so do not need to keep state_tables[]
> there any more after system init.
> 
> It will save about 3~4k memory, also benefits mobile devices.
> Here changing them as __initdata, also removing global var
> cpuidle_state_table pointer.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

