Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3B1JqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:46:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49620 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3B1JqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:46:13 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-f1-512f27642c38
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: 
In-reply-to: 
Subject: Re: [PATCH] backlight: atmel-pwm-bl: remove erroneous __exit annotation
Date: Thu, 28 Feb 2013 18:46:12 +0900
Message-id: <000801ce1598$7168f800$543ae800$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4VaMZK/2U6vu2+TDmktd1woodJ1AAL2NZA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI90Udf1Ag7kP1SzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErowjk5uY
	CyZzVexo3M3WwLiQo4uRk0NCwETiwYTpzBC2mMSFe+vZuhi5OIQEljFKLF7zjgmmqPN2L1Ri
	OqPE6ckXwDqEBH4BVW2uB7HZBNQkvnw5zN7FyMEhIqAv0daiARJmFiiV2PrgPQtIWEiAW2J1
	cxBImFOAR2Ldn05mkLCwQIBE+7wYkDCLgKrE7f7NLCA2r4CtxIm559ggbEGJH5PvsUBM1JLY
	vK2JFcKWl9i85i3YGAkBdYlHf3VBwiICRhIPL/eyQ5SISOx78Y4R5HgJgXPsErf3LWaB2CUg
	8W3yIRaIXlmJTQegoSApcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRkV5x
	Ym5xaV66XnJ+7iZGSDz27WC8ecD6EGMy0PqJzFKiyfnAeM4riTc0NjYxMzE1Mbc0NTclTVhJ
	nFf+kkygkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkb5/yYaATtcWnT8TbjldFwVs47JPUm0
	MqgNr9gRxpvWzZ3+9LrInGUnbUyNw6ZebDdWjtXXqVD8pmLAPP3grIDF/d7MfkUJQn9ezVDn
	vF2+5XTXg6M+y9+7HDYoW/PIc4Z3yWc5gS/lm3kltW59XXuSz7CPIa0pfuv092ueR9he/pcZ
	8Sd0vRJLcUaioRZzUXEiAHjtImXdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd0Udf1Ag85uJYs569ewWVxeeInV
	4vKuOWwWu3c9ZXVg8Tgx4zeLx575P1g9+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwjjHjyOQm5oLJXBU7GnezNTAu5Ohi5OSQEDCR6LzdywZhi0lcuLce
	yObiEBKYzihxevIFZpCEkMAvRonFm+tBbDYBNYkvXw6zdzFycIgI6Eu0tWiAhJkFSiW2PnjP
	AhIWEuCWWN0cBBLmFOCRWPenkxkkLCwQINE+LwYkzCKgKnG7fzMLiM0rYCtxYu45NghbUOLH
	5HssEBO1JDZva2KFsOUlNq95CzZGQkBd4tFfXZCwiICRxMPLvewQJSIS+168Y5zAKDQLyaRZ
	SCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo/2Z9A7GVQ0WhxgFOBiV
	eHg7TPQChVgTy4orcw8xSnAwK4nwuvDrBwrxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjAR
	5ZXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQQHpiSWp2ampBahHMFiYOTqkGRsmHarOCHdZo
	6vHPM0+Mv77fQaw2Tstd0uNEws5/t9Ibfq24+rcmfd0KydC62kXdvWZhWoWWlrVBdp+ELqk+
	CVtzZ5eF0T5VHQ+jG+Ixl+V6koqvGNWHbPQouhJncfSXu6CAxK/ZTcwsce3PMv8GeEzYcaiW
	UfacQlyhpC+jsoRLX6xVTKMSS3FGoqEWc1FxIgCcPD/8OgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 28, 2013 1:05 PM, Jingoo Han wrote:
> 
> CONFIG_HOTPLUG was removed, so __devexit or __exit of remove()
> should not be used.

This driver also use platform_driver_probe().
So, this patch is useless.

Please, abandon this patch.
Thank you.

Best regards,
Jingoo Han

> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/atmel-pwm-bl.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> index de5e5e7..24b90fa 100644
> --- a/drivers/video/backlight/atmel-pwm-bl.c
> +++ b/drivers/video/backlight/atmel-pwm-bl.c
> @@ -203,7 +203,7 @@ err_free_mem:
>  	return retval;
>  }
> 
> -static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
> +static int atmel_pwm_bl_remove(struct platform_device *pdev)
>  {
>  	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
> 
> @@ -222,7 +222,7 @@ static struct platform_driver atmel_pwm_bl_driver = {
>  		.name = "atmel-pwm-bl",
>  	},
>  	/* REVISIT add suspend() and resume() */
> -	.remove = __exit_p(atmel_pwm_bl_remove),
> +	.remove = atmel_pwm_bl_remove,
>  };
> 
>  static int __init atmel_pwm_bl_init(void)
> --
> 1.7.2.5


