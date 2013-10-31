Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3JaQQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:16:15 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:49866 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3JaQQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:16:13 -0400
Date: Thu, 31 Oct 2013 09:16:03 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, mturquette@linaro.org,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH 3/4] mfd: sec-core: Add cells for S5M8767-clocks
Message-ID: <20131031161603.GB9587@lee--X1>
References: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
 <1383202124-1775-4-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383202124-1775-4-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013, Tushar Behera wrote:

> S5M8767 chip has 3 crystal oscillators running at 32KHz. These are
> supported by s2mps11-clk driver.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/sec-core.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index 34c18fb..020b86b 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -56,7 +56,9 @@ static struct mfd_cell s5m8767_devs[] = {
>  		.name = "s5m8767-pmic",
>  	}, {
>  		.name = "s5m-rtc",
> -	},
> +	}, {
> +		.name = "s5m8767-clk",
> +	}
>  };
>  
>  static struct mfd_cell s2mps11_devs[] = {

Acked-by: Lee Jones <lee.jones@linaro.org>

I'd prefer to take this patch in via the MFD tree once you have
support from the other maintainers for the set.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
