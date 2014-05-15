Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaEOOb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:31:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33840 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaEOOb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:31:57 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] ARM: QCOM: Enable ARM_AMBA option for Qcom SOCS.
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1400148535-30772-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Thu, 15 May 2014 09:31:52 -0500
Cc: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4FB5A6A0-B4C5-4E97-AD7D-8049CFA60393@codeaurora.org>
References: <1400148535-30772-1-git-send-email-srinivas.kandagatla@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15, 2014, at 5:08 AM, Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:

> As some of the IPs on Qualcomm SOCs are based on ARM PrimeCell IPs.
> For example SDCC controller is PrimeCell MCI pl180. Adding this option will
> give flexibility to reuse the existing drivers as it is without major
> modifications.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> arch/arm/mach-qcom/Kconfig | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
> index a028be2..5bac591 100644
> --- a/arch/arm/mach-qcom/Kconfig
> +++ b/arch/arm/mach-qcom/Kconfig
> @@ -2,6 +2,7 @@ config ARCH_QCOM
> 	bool "Qualcomm Support" if ARCH_MULTI_V7
> 	select ARCH_REQUIRE_GPIOLIB
> 	select ARM_GIC
> +	select ARM_AMBA
> 	select CLKSRC_OF
> 	select GENERIC_CLOCKEVENTS
> 	select HAVE_SMP
> -- 
> 1.9.1

I’d rather have the driver have the select of ARM_AMBA and not the core support.  We clearly don’t need to build ARM_AMBA in to function.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

