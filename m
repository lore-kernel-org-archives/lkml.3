Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaJOJES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:04:18 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63715 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaJOJEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:04:15 -0400
Date: Wed, 15 Oct 2014 11:04:10 +0200
From: Lee Jones <lee.jones@linaro.org>
To: Will Sheppard <wsheppard@embedded-bits.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: arizona-spi: Add lines after declarations -
 checkpatch catch
Message-ID: <20141015090410.GA9900@lee--X1>
References: <1413362327-17378-1-git-send-email-wsheppard@embedded-bits.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413362327-17378-1-git-send-email-wsheppard@embedded-bits.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014, Will Sheppard wrote:

> This was found whilst running checkpatch.pl on arizona-spi.
> 
> WARNING: Missing a blank line after declarations
> +       struct arizona *arizona = spi_get_drvdata(spi);
> +       arizona_dev_exit(arizona);
> 
> Signed-off-by: Will Sheppard <wsheppard@embedded-bits.co.uk>
> ---
>  drivers/mfd/arizona-spi.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied for v3.19.

> diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
> index 5145d78..8ef58bc 100644
> --- a/drivers/mfd/arizona-spi.c
> +++ b/drivers/mfd/arizona-spi.c
> @@ -75,7 +75,9 @@ static int arizona_spi_probe(struct spi_device *spi)
>  static int arizona_spi_remove(struct spi_device *spi)
>  {
>  	struct arizona *arizona = spi_get_drvdata(spi);
> +
>  	arizona_dev_exit(arizona);
> +
>  	return 0;
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
