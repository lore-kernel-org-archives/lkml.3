Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaHDIJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:09:42 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35381 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaHDIJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:09:40 -0400
Date: Mon, 4 Aug 2014 09:09:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Hans Wennborg <hans@hanshq.net>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/19] mfd: htc-i2cpld: fix %d confusingly prefixed with
 0x in format string
Message-ID: <20140804080935.GC3935@lee--X1>
References: <1407111555-14739-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407111555-14739-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Aug 2014, Hans Wennborg wrote:

> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/mfd/htc-i2cpld.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
> index b44f020..6bdb78c 100644
> --- a/drivers/mfd/htc-i2cpld.c
> +++ b/drivers/mfd/htc-i2cpld.c
> @@ -404,7 +404,7 @@ static int htcpld_register_chip_i2c(
>  	}
>  
>  	i2c_set_clientdata(client, chip);
> -	snprintf(client->name, I2C_NAME_SIZE, "Chip_0x%d", client->addr);
> +	snprintf(client->name, I2C_NAME_SIZE, "Chip_0x%x", client->addr);
>  	chip->client = client;
>  
>  	/* Reset the chip */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
