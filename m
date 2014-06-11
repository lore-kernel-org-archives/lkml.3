Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbaFKJOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:14:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbaFKJOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:14:11 -0400
Message-ID: <53981DE1.3070007@suse.de>
Date: Wed, 11 Jun 2014 11:14:09 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 1/2] clk: qcom: add clocks necessary for apq8064 sdcc
References: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org> <1402433906-19309-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1402433906-19309-2-git-send-email-sboyd@codeaurora.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.06.2014 22:58, schrieb Stephen Boyd:
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> 
> This patch adds clocks necessary for SD card controller on apq8064 SOC.
> Without this patch the clocks are visible to the sdcc driver.

Was this maybe meant to read "invisible"?

Regards,
Andreas

> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Reviewed-by: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clk/qcom/gcc-msm8960.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
> index f4ffd91901f8..c47a75829b2b 100644
> --- a/drivers/clk/qcom/gcc-msm8960.c
> +++ b/drivers/clk/qcom/gcc-msm8960.c
> @@ -2876,6 +2876,14 @@ static struct clk_regmap *gcc_apq8064_clks[] = {
>  	[GSBI7_QUP_SRC] = &gsbi7_qup_src.clkr,
>  	[GSBI7_QUP_CLK] = &gsbi7_qup_clk.clkr,
>  	[GSBI7_H_CLK] = &gsbi7_h_clk.clkr,
> +	[SDC1_SRC] = &sdc1_src.clkr,
> +	[SDC1_CLK] = &sdc1_clk.clkr,
> +	[SDC2_SRC] = &sdc2_src.clkr,
> +	[SDC2_CLK] = &sdc2_clk.clkr,
> +	[SDC3_SRC] = &sdc3_src.clkr,
> +	[SDC3_CLK] = &sdc3_clk.clkr,
> +	[SDC4_SRC] = &sdc4_src.clkr,
> +	[SDC4_CLK] = &sdc4_clk.clkr,
>  };
>  
>  static const struct regmap_config gcc_msm8960_regmap_config = {
> 


-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
