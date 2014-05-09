Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbaEIVyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:54:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59725 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700AbaEIVyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:54:31 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v2] clk: qcom: add clocks necessary for apq8064 sdcc
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1399664045-18870-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 9 May 2014 14:54:23 -0700
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <96AEFF95-799C-4908-953C-0BBAC8F2EB8F@codeaurora.org>
References: <1399661305-11641-1-git-send-email-srinivas.kandagatla@linaro.org> <1399664045-18870-1-git-send-email-srinivas.kandagatla@linaro.org>
To: srinivas.kandagatla@linaro.org
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 9, 2014, at 12:34 PM, srinivas.kandagatla@linaro.org wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> 
> This patch adds clocks necessary for SD card controller on apq8064 SOC.
> Without this patch the clocks are visible to the sdcc driver.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> drivers/clk/qcom/gcc-msm8960.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
> index f4ffd91..c47a758 100644
> --- a/drivers/clk/qcom/gcc-msm8960.c
> +++ b/drivers/clk/qcom/gcc-msm8960.c
> @@ -2876,6 +2876,14 @@ static struct clk_regmap *gcc_apq8064_clks[] = {
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
> };
> 

Reviewed-by: Kumar Gala <galak@codeaurora.org>

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

