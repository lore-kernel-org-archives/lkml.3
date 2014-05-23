Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaEWWzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:55:39 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59016 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaEWWzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:55:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Georgi Djakov <gdjakov@mm-sol.com>, sboyd@codeaurora.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1400604654-27701-1-git-send-email-gdjakov@mm-sol.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Georgi Djakov" <gdjakov@mm-sol.com>
References: <1400604654-27701-1-git-send-email-gdjakov@mm-sol.com>
Message-ID: <20140523225526.23136.87517@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: qcom: Fix blsp2_ahb_clk register offset
Date: Fri, 23 May 2014 15:55:26 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Georgi Djakov (2014-05-20 09:50:54)
> The address of the blsp2_ahb_clk register is incorrect. Fix it.
> 
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

Applied to clk-next.

Regards,
Mike

> ---
>  drivers/clk/qcom/gcc-msm8974.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
> index 51d457e..7968ed2 100644
> --- a/drivers/clk/qcom/gcc-msm8974.c
> +++ b/drivers/clk/qcom/gcc-msm8974.c
> @@ -1340,7 +1340,7 @@ static struct clk_branch gcc_blsp1_uart6_apps_clk = {
>  };
>  
>  static struct clk_branch gcc_blsp2_ahb_clk = {
> -       .halt_reg = 0x05c4,
> +       .halt_reg = 0x0944,
>         .halt_check = BRANCH_HALT_VOTED,
>         .clkr = {
>                 .enable_reg = 0x1484,
> -- 
> 1.7.9.5
> 
