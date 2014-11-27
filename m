Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaK0Byo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:54:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48757 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaK0Byn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:54:43 -0500
Message-ID: <54768461.3050501@codeaurora.org>
Date: Wed, 26 Nov 2014 17:54:41 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Update processor_modes for hyp and monitor mode
References: <1416272732-20573-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1416272732-20573-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 05:05 PM, Stephen Boyd wrote:
> If the kernel is running in hypervisor mode or monitor mode we'll
> print UK6_32 or UK10_32 if we call into __show_regs(). Let's
> update these strings to indicate the new modes that didn't exist
> when this code was written.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Can I throw this into the patch tracker?

>   arch/arm/kernel/process.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index fe972a2f3df3..fdfa3a78ec8c 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -51,8 +51,8 @@ EXPORT_SYMBOL(__stack_chk_guard);
>   static const char *processor_modes[] __maybe_unused = {
>     "USER_26", "FIQ_26" , "IRQ_26" , "SVC_26" , "UK4_26" , "UK5_26" , "UK6_26" , "UK7_26" ,
>     "UK8_26" , "UK9_26" , "UK10_26", "UK11_26", "UK12_26", "UK13_26", "UK14_26", "UK15_26",
> -  "USER_32", "FIQ_32" , "IRQ_32" , "SVC_32" , "UK4_32" , "UK5_32" , "UK6_32" , "ABT_32" ,
> -  "UK8_32" , "UK9_32" , "UK10_32", "UND_32" , "UK12_32", "UK13_32", "UK14_32", "SYS_32"
> +  "USER_32", "FIQ_32" , "IRQ_32" , "SVC_32" , "UK4_32" , "UK5_32" , "MON_32" , "ABT_32" ,
> +  "UK8_32" , "UK9_32" , "HYP_32", "UND_32" , "UK12_32", "UK13_32", "UK14_32", "SYS_32"
>   };
>   
>   static const char *isa_modes[] __maybe_unused = {


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

