Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaGVOGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:06:39 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56431 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaGVOGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:06:38 -0400
Date: Tue, 22 Jul 2014 15:06:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: pramod.gurav.etc@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: max8925-i2c: Add some blank lines before return
Message-ID: <20140722140631.GG16065@lee--X1>
References: <1406033048-16873-1-git-send-email-pramod.gurav.etc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406033048-16873-1-git-send-email-pramod.gurav.etc@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, pramod.gurav.etc@gmail.com wrote:

> From: Pramod Gurav <pramod.gurav.etc@gmail.com>
> 
> Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
> ---
> Lee, This is what I was referring to when I said there are more such
> changes needed. Hope they are ok.
> 
> Sending just to you as I could not send it on that mail chain.

I can't accept any patch which hasn't been on the list.  Please find a
way to do so.

> Please add these with your changes if ok.
> 
>  drivers/mfd/max8925-i2c.c |    5 +++++
>  1 file changed, 5 insertions(+)

Can you rebase this on top of my for-mfd-next branc please?

> diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
> index a83eed5..d085cdf 100644
> --- a/drivers/mfd/max8925-i2c.c
> +++ b/drivers/mfd/max8925-i2c.c
> @@ -31,6 +31,7 @@ static inline int max8925_read_device(struct i2c_client *i2c,
>  			return ret;
>  		*(unsigned char *)dest = (unsigned char)ret;
>  	}
> +
>  	return ret;
>  }
>  
> @@ -46,6 +47,7 @@ static inline int max8925_write_device(struct i2c_client *i2c,
>  	ret = i2c_master_send(i2c, buf, bytes + 1);
>  	if (ret < 0)
>  		return ret;
> +
>  	return 0;
>  }
>  
> @@ -145,6 +147,7 @@ static int max8925_dt_init(struct device_node *np, struct device *dev,
>  		dev_err(dev, "Not found maxim,tsc-irq property\n");
>  		return -EINVAL;
>  	}
> +
>  	return 0;
>  }
>  
> @@ -220,6 +223,7 @@ static int max8925_suspend(struct device *dev)
>  
>  	if (device_may_wakeup(dev) && chip->wakeup_flag)
>  		enable_irq_wake(chip->core_irq);
> +
>  	return 0;
>  }
>  
> @@ -230,6 +234,7 @@ static int max8925_resume(struct device *dev)
>  
>  	if (device_may_wakeup(dev) && chip->wakeup_flag)
>  		disable_irq_wake(chip->core_irq);
> +
>  	return 0;
>  }
>  #endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
