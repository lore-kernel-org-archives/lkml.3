Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaETIYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:24:10 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:16079 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaETIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:24:08 -0400
Message-ID: <537B111D.20808@atmel.com>
Date: Tue, 20 May 2014 10:23:57 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFwaGHDq2wgUG9nZ2k=?= <poggi.raph@gmail.com>,
        <linux-spi@vger.kernel.org>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: atmel: fix typo in dev_err
References: <1400571711-13137-1-git-send-email-poggi.raph@gmail.com>
In-Reply-To: <1400571711-13137-1-git-send-email-poggi.raph@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/2014 09:41, Raphaël Poggi :
> Fix typo in dev_err.
> 
> Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/spi/spi-atmel.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index 079e6b1..7a1788b 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -1122,7 +1122,7 @@ static int atmel_spi_one_transfer(struct spi_master *master,
>  		atmel_spi_lock(as);
>  		if (WARN_ON(ret == 0)) {
>  			dev_err(&spi->dev,
> -				"spi trasfer timeout, err %d\n", ret);
> +				"spi transfer timeout, err %d\n", ret);
>  			as->done_status = -EIO;
>  		} else {
>  			ret = 0;
> 


-- 
Nicolas Ferre
