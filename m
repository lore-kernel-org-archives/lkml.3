Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbaDIOAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:00:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56540 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933470AbaDIOAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:00:12 -0400
Message-ID: <53455268.4030003@codeaurora.org>
Date: Wed, 09 Apr 2014 10:00:08 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: msm: Make MSM_HAS_DEBUG_UART_HS option visible to
 multiplatform targets
References: <1397048912-6738-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1397048912-6738-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

On 04/09/2014 09:08 AM, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> High Speed UART is available also in new multiplatform QCOM targets.

> diff --git a/arch/arm/include/debug/msm.S b/arch/arm/include/debug/msm.S
> index 9d653d4..09ff7b7 100644
> --- a/arch/arm/include/debug/msm.S
> +++ b/arch/arm/include/debug/msm.S
> @@ -39,11 +39,14 @@
>  #ifdef CONFIG_DEBUG_MSM8660_UART
>  #define MSM_DEBUG_UART_BASE	0xF0040000
>  #define MSM_DEBUG_UART_PHYS	0x19C40000
> +#define MSM_HAS_DEBUG_UART_HS
>  #endif
> 
>  #ifdef CONFIG_DEBUG_MSM8960_UART
> +#define MSM_HAS_DEBUG_UART_HS

This appears to be duplicated.

>  #define MSM_DEBUG_UART_BASE	0xF0040000
>  #define MSM_DEBUG_UART_PHYS	0x16440000
> +#define MSM_HAS_DEBUG_UART_HS
>  #endif
> 
>  #ifdef CONFIG_DEBUG_MSM8974_UART

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
