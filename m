Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbaFEAec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:34:32 -0400
Received: from mx7.pku.edu.cn ([162.105.129.170]:56367 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753715AbaFEAe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:34:29 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.475
Date: Thu, 5 Jun 2014 08:34:12 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Message-ID: <1001589690.39308.1401928452253.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1401820203-21556-1-git-send-email-sboyd@codeaurora.org>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_unicore32:_Remove_?=
 =?utf-8?Q?ARCH=5FHAS=5FCPUFREQ_config_option?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Stephen Boyd <sboyd@codeaurora.org> 写道：
> This config exists entirely to hide the cpufreq menu from the
> kernel configuration unless a platform has selected it. Nothing
> is actually built if this config is 'Y' and it just leads to more
> patches that add a select under a platform Kconfig so that some
> other CPUfreq option can be chosen. Let's remove the option so
> that we can always enable CPUfreq drivers on unicore32 platforms.
> 
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks, I'll push it in my repo.

Signed-off-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

> ---
>  arch/unicore32/Kconfig | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index aafad6fa1667..928237a7b9ca 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -51,9 +51,6 @@ config ARCH_HAS_ILOG2_U32
>  config ARCH_HAS_ILOG2_U64
>  	bool
>  
> -config ARCH_HAS_CPUFREQ
> -	bool
> -
>  config GENERIC_HWEIGHT
>  	def_bool y
>  
> @@ -87,7 +84,6 @@ config ARCH_PUV3
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_CLK
>  	select ARCH_REQUIRE_GPIOLIB
> -	select ARCH_HAS_CPUFREQ
>  
>  # CONFIGs for ARCH_PUV3
>  
> @@ -198,9 +194,7 @@ menu "Power management options"
>  
>  source "kernel/power/Kconfig"
>  
> -if ARCH_HAS_CPUFREQ
>  source "drivers/cpufreq/Kconfig"
> -endif
>  
>  config ARCH_SUSPEND_POSSIBLE
>  	def_bool y if !ARCH_FPGA
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

