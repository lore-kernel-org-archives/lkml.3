Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3IFUuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:50:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46572 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3IFUuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:50:09 -0400
Message-ID: <522A3FFD.9020105@codeaurora.org>
Date: Fri, 06 Sep 2013 13:50:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: msm: Remove irqs-*.h files for DT based targets
References: <20130906195300.GJ808@joshc.qualcomm.com> <1378499517-24014-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1378499517-24014-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/13 13:31, Stephen Boyd wrote:
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 905efc8..30b3342 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -50,6 +50,7 @@ config ARCH_MSM8X60
>  	select HAVE_SMP
>  	select MSM_SCM if SMP
>  	select USE_OF
> +	select SPARSE_IRQ
>  
>  config ARCH_MSM8960
>  	bool "MSM8960"
> @@ -59,6 +60,7 @@ config ARCH_MSM8960
>  	select GPIO_MSM_V2
>  	select MSM_SCM if SMP
>  	select USE_OF
> +	select SPARSE_IRQ

Gah, I guess this needs to be sorted alphabetically.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

