Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaEUPTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:19:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46278 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaEUPTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:19:02 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v1 3/4] ARM: qcom: Add APQ8084-MTP board to mach-qcom
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1400684225-21381-4-git-send-email-gdjakov@mm-sol.com>
Date: Wed, 21 May 2014 10:18:53 -0500
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        sboyd@codeaurora.org, rvaswani@codeaurora.org, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A6B00F86-FFD3-4FEF-B39E-EAA511565B80@codeaurora.org>
References: <1400684225-21381-1-git-send-email-gdjakov@mm-sol.com> <1400684225-21381-4-git-send-email-gdjakov@mm-sol.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 21, 2014, at 9:57 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:

> Add board compatibility string to the board machine descriptors.
> 
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
> arch/arm/mach-qcom/board.c |    1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-qcom/board.c b/arch/arm/mach-qcom/board.c
> index bae617e..ae0a405 100644
> --- a/arch/arm/mach-qcom/board.c
> +++ b/arch/arm/mach-qcom/board.c
> @@ -18,6 +18,7 @@ static const char * const qcom_dt_match[] __initconst = {
> 	"qcom,msm8660-surf",
> 	"qcom,msm8960-cdp",
> 	"qcom,apq8074-dragonboard",
> +	"qcom,apq8084-mtp",
> 	NULL
> };
> 
> -- 
> 1.7.9.5
> 

Let’s just make this “qcom,apq8084” to cover other future apq8084 based boards.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

