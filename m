Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3KGRRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:17:21 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52876 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754034Ab3KGRRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:17:18 -0500
Message-ID: <527BCB12.8090501@free-electrons.com>
Date: Thu, 07 Nov 2013 18:17:06 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>, mturquette@linaro.org,
        jason@lakedaemon.net
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: mvebu: staticize of_cpu_clk_setup
References: <1383814773-5231-1-git-send-email-jszhang@marvell.com>
In-Reply-To: <1383814773-5231-1-git-send-email-jszhang@marvell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 09:59, Jisheng Zhang wrote:
> This symbol is used only in this file. The patch fix the following
> sparse warning:
> warning: symbol 'of_cpu_clk_setup' was not declared. Should it be static?
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


Thanks,

Gregory

> ---
>  drivers/clk/mvebu/clk-cpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
> index 1466865..8ebf757 100644
> --- a/drivers/clk/mvebu/clk-cpu.c
> +++ b/drivers/clk/mvebu/clk-cpu.c
> @@ -101,7 +101,7 @@ static const struct clk_ops cpu_ops = {
>  	.set_rate = clk_cpu_set_rate,
>  };
>  
> -void __init of_cpu_clk_setup(struct device_node *node)
> +static void __init of_cpu_clk_setup(struct device_node *node)
>  {
>  	struct cpu_clk *cpuclk;
>  	void __iomem *clock_complex_base = of_iomap(node, 0);
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
