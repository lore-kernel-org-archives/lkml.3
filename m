Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaAFJan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:30:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60391 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaAFJal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:30:41 -0500
Date: Mon, 6 Jan 2014 09:30:33 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 1/2] mfd: twl6040: Staticize local variable
Message-ID: <20140106093033.GC23772@lee--X1>
References: <1387605142-4743-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387605142-4743-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Dec 2013, Sachin Kamat wrote:

> 'twl6040_patch' is local to this file.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/mfd/twl6040.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
> index 51b6df1a7949..75316fb33448 100644
> --- a/drivers/mfd/twl6040.c
> +++ b/drivers/mfd/twl6040.c
> @@ -86,7 +86,7 @@ static struct reg_default twl6040_defaults[] = {
>  	{ 0x2E, 0x00 }, /* REG_STATUS	(ro) */
>  };
>  
> -struct reg_default twl6040_patch[] = {
> +static struct reg_default twl6040_patch[] = {
>  	/* Select I2C bus access to dual access registers */
>  	{ TWL6040_REG_ACCCTL, 0x09 },
>  };

This has already been fixed.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
