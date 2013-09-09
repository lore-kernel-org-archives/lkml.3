Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab3III7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:59:00 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:65246 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3III66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:58:58 -0400
Date: Mon, 9 Sep 2013 09:58:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: wm8994: Remove unused irq_lock
Message-ID: <20130909085854.GB22938@lee--X1>
References: <1378486115-4926-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378486115-4926-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> Since the conversion to regmap-irq irq_lock has been unused.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  include/linux/mfd/wm8994/core.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
> index 3fbcf3d..eefafa6 100644
> --- a/include/linux/mfd/wm8994/core.h
> +++ b/include/linux/mfd/wm8994/core.h
> @@ -56,8 +56,6 @@ struct irq_domain;
>  #define WM8994_IRQ_GPIO(x) (x + WM8994_IRQ_TEMP_WARN)
>  
>  struct wm8994 {
> -	struct mutex irq_lock;
> -
>  	struct wm8994_pdata pdata;
>  
>  	enum wm8994_type type;

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
