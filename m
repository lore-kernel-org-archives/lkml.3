Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3EAUgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 16:36:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21868 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab3EAUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 16:36:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,591,1363158000"; 
   d="scan'208";a="43251660"
Message-ID: <51817CBE.4050003@codeaurora.org>
Date: Wed, 01 May 2013 16:36:14 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: xen-devel@lists.xensource.com, linux@arm.linux.org.uk,
        marc.zyngier@arm.com, catalin.marinas@arm.com, konrad.wilk@oracle.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] arm_arch_timer: introduce arch_timer_stolen_ticks
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com> <1367436460-10183-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1367436460-10183-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 05/01/2013 03:27 PM, Stefano Stabellini wrote:
> Introduce a function, called arch_timer_stolen_ticks, called from the
> arch_timer interrupt handler to account for stolen ticks.

[...]

> diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
> index 7ade91d..30db413 100644
> --- a/arch/arm/include/asm/arch_timer.h
> +++ b/arch/arm/include/asm/arch_timer.h
> @@ -13,6 +13,11 @@
>  int arch_timer_of_register(void);
>  int arch_timer_sched_clock_init(void);
>  
> +/* per-platform function to calculate stolen ticks (clock cycles stolen
> + * to the vcpu by the hypervisor).

Stolen from the vcpu by the hypervisor?

Is the hypervisor adjusting the Virtual Offset Register?

[...]

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
