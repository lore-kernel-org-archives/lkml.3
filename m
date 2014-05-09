Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbaEITWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:22:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50498 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbaEITWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:22:00 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] clk: qcom: add clocks necessary for apq8064 sdcc
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1399661305-11641-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 9 May 2014 12:21:57 -0700
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <751695A1-0A84-47AE-B3EC-81A1F5C14101@codeaurora.org>
References: <1399661305-11641-1-git-send-email-srinivas.kandagatla@linaro.org>
To: srinivas.kandagatla@linaro.org
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 9, 2014, at 11:48 AM, srinivas.kandagatla@linaro.org wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> 
> This patch adds clocks necessary for SD card controller on apq8064 SOC.
> Without this patch the clocks are visible to the sdcc driver.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> drivers/clk/qcom/gcc-msm8960.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
> index f4ffd91..9bd3238 100644
> --- a/drivers/clk/qcom/gcc-msm8960.c
> +++ b/drivers/clk/qcom/gcc-msm8960.c
> @@ -2876,6 +2876,16 @@ static struct clk_regmap *gcc_apq8064_clks[] = {
> 	[GSBI7_QUP_SRC] = &gsbi7_qup_src.clkr,
> 	[GSBI7_QUP_CLK] = &gsbi7_qup_clk.clkr,
> 	[GSBI7_H_CLK] = &gsbi7_h_clk.clkr,
> +	[SDC1_SRC] = &sdc1_src.clkr,
> +	[SDC1_CLK] = &sdc1_clk.clkr,
> +	[SDC2_SRC] = &sdc2_src.clkr,
> +	[SDC2_CLK] = &sdc2_clk.clkr,
> +	[SDC3_SRC] = &sdc3_src.clkr,
> +	[SDC3_CLK] = &sdc3_clk.clkr,
> +	[SDC4_SRC] = &sdc4_src.clkr,
> +	[SDC4_CLK] = &sdc4_clk.clkr,
> +	[SDC5_SRC] = &sdc5_src.clkr,
> +	[SDC5_CLK] = &sdc5_clk.clkr,
> };

There are only 4 SDCs on APQ8064

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

