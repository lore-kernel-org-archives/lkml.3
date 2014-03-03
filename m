Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaCCRGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:06:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54650 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaCCRGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:06:05 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 1/2] spmi: pmic_arb: make selectable on ARCH_QCOM
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1393865384-28145-1-git-send-email-joshc@codeaurora.org>
Date: Mon, 3 Mar 2014 11:06:00 -0600
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <383D34BB-AA5E-4FD7-9E71-E26787937642@codeaurora.org>
References: <1393865384-28145-1-git-send-email-joshc@codeaurora.org>
To: Josh Cartwright <joshc@codeaurora.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 3, 2014, at 10:49 AM, Josh Cartwright <joshc@codeaurora.org> wrote:

> With the split of Qualcomm MSM support into legacy and multiplatform,
> the SPMI PMIC arb driver is only relevant on the multiplatform supported
> SoCs. Switch the Kconfig depends to ARCH_QCOM.
> 
> Cc: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
> drivers/spmi/Kconfig | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spmi/Kconfig b/drivers/spmi/Kconfig
> index 075bd79..bf1295e 100644
> --- a/drivers/spmi/Kconfig
> +++ b/drivers/spmi/Kconfig
> @@ -14,8 +14,8 @@ config SPMI_MSM_PMIC_ARB
> 	tristate "Qualcomm MSM SPMI Controller (PMIC Arbiter)"
> 	depends on ARM
> 	depends on IRQ_DOMAIN
> -	depends on ARCH_MSM || COMPILE_TEST
> -	default ARCH_MSM
> +	depends on ARCH_QCOM || COMPILE_TEST
> +	default ARCH_QCOM
> 	help
> 	  If you say yes to this option, support will be included for the
> 	  built-in SPMI PMIC Arbiter interface on Qualcomm MSM family

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

