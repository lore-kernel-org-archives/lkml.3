Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaG1Gyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:54:47 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:45334 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaG1Gyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:54:44 -0400
Date: Mon, 28 Jul 2014 07:54:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: linux-kernel@vger.kernel.org, spk.linux@gmail.com
Subject: Re: [PATCH Resend 2/2] mfd: tps65912-spi: Remove unused variable
Message-ID: <20140728065439.GC5273@lee--X1>
References: <1405684817-20171-1-git-send-email-sachin.kamat@samsung.com>
 <1405684817-20171-2-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405684817-20171-2-git-send-email-sachin.kamat@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Sachin Kamat wrote:

> ‘rx_buf’ is not used in this function.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
> ---
>  drivers/mfd/tps65912-spi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/tps65912-spi.c b/drivers/mfd/tps65912-spi.c
> index 69a5178bf152..de60ad98bd9f 100644
> --- a/drivers/mfd/tps65912-spi.c
> +++ b/drivers/mfd/tps65912-spi.c
> @@ -32,10 +32,9 @@ static int tps65912_spi_write(struct tps65912 *tps65912, u8 addr,
>  	unsigned long spi_data = 1 << 23 | addr << 15 | *data;
>  	struct spi_transfer xfer;
>  	struct spi_message msg;
> -	u32 tx_buf, rx_buf;
> +	u32 tx_buf;
>  
>  	tx_buf = spi_data;
> -	rx_buf = 0;
>  
>  	xfer.tx_buf	= &tx_buf;
>  	xfer.rx_buf	= NULL;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
