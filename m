Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaE1Ig5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:36:57 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41745 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbaE1Igy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:36:54 -0400
Date: Wed, 28 May 2014 09:36:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: ux500: Staticize ux500_soc_attr
Message-ID: <20140528083649.GB10803@lee--X1>
References: <1401248417-10146-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401248417-10146-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Sachin Kamat wrote:

> 'ux500_soc_attr' is local to this file. While at it also make it
> const to match the argument list of device_create_file.

What's going on Sachin?  I Acked v2 of this patch an hour ago, yet
you've resent it as a v1 and without the Ack?

> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  arch/arm/mach-ux500/cpu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
> index db16b5a04ad5..dbb2970ee7da 100644
> --- a/arch/arm/mach-ux500/cpu.c
> +++ b/arch/arm/mach-ux500/cpu.c
> @@ -125,7 +125,7 @@ static void __init soc_info_populate(struct soc_device_attribute *soc_dev_attr,
>  	soc_dev_attr->revision = ux500_get_revision();
>  }
>  
> -struct device_attribute ux500_soc_attr =
> +static const struct device_attribute ux500_soc_attr =
>  	__ATTR(process,  S_IRUGO, ux500_get_process,  NULL);
>  
>  struct device * __init ux500_soc_device_init(const char *soc_id)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
