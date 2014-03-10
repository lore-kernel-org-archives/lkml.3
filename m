Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaCJMqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:46:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43140 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaCJMq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:46:29 -0400
Date: Mon, 10 Mar 2014 12:46:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 2/3] mfd: sec-core: Add of_compatible strings for MFD
 cells
Message-ID: <20140310124623.GA18561@lee--X1>
References: <1394454858-3139-1-git-send-email-k.kozlowski@samsung.com>
 <1394454858-3139-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394454858-3139-3-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add of_compatible strings for S5M8767 RTC, S5M8767 clock and S2MPS14
> clock MFD cells.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/sec-core.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index d163c66edebb..e8ac2e3c1f58 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -57,8 +57,10 @@ static const struct mfd_cell s5m8767_devs[] = {
>  		.name = "s5m8767-pmic",
>  	}, {
>  		.name = "s5m-rtc",
> +		.of_compatible = "samsung,s5m8767-rtc",
>  	}, {
>  		.name = "s5m8767-clk",
> +		.of_compatible = "samsung,s5m8767-clk",
>  	}
>  };
>  
> @@ -77,6 +79,7 @@ static const struct mfd_cell s2mps14_devs[] = {
>  		.name = "s2mps14-rtc",
>  	}, {
>  		.name = "s2mps14-clk",
> +		.of_compatible = "samsung,s2mps14-clk",
>  	}
>  };

Any reason for not applying compatible strings for the other devices?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
