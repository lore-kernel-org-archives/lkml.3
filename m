Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaFBTgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:36:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54935 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaFBTgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:36:06 -0400
Date: Mon, 2 Jun 2014 12:36:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] clk: qcom: Add APQ8084 Global Clock Controller
 support
Message-ID: <20140602193603.GM20486@codeaurora.org>
References: <1401551134-28485-1-git-send-email-gdjakov@mm-sol.com>
 <1401551134-28485-3-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401551134-28485-3-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Georgi Djakov wrote:
> +
> +static const struct qcom_reset_map gcc_apq8084_resets[] = {

> +	[GCC_VENUS0_BCR] = { 0x1020 },

> +	[GCC_VPU_BCR] = { 0x1400 },

> +	[GCC_MDSS_BCR] = { 0x2300 },
> +	[GCC_AVSYNC_BCR] = { 0x2400 },
> +	[GCC_OXILI_BCR] = { 0x4020 },
> +	[GCC_OXILICX_BCR] = { 0x4030 },
> +	[GCC_OCMEMCX_BCR] = { 0x4050 },

These aren't in global clock control (looks like mmcc).

> +#define GCC_VENUS0_BCR			56

> +#define GCC_VPU_BCR			76


> +#define GCC_MDSS_BCR			93
> +#define GCC_AVSYNC_BCR			94
> +#define GCC_OXILI_BCR			95
> +#define GCC_OXILICX_BCR			96
> +#define GCC_OCMEMCX_BCR			97

Ditto

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
