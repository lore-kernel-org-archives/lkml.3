Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3COQH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:07:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:43725 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3COQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:07:25 -0400
Message-ID: <51434736.5020004@atmel.com>
Date: Fri, 15 Mar 2013 17:07:18 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: <ludovic.desroches@atmel.com>, <linux-i2c@vger.kernel.org>,
        <wsa@the-dreams.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add maintainer entry for atmel i2c driver
References: <1363361577-7770-1-git-send-email-ludovic.desroches@atmel.com>
In-Reply-To: <1363361577-7770-1-git-send-email-ludovic.desroches@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 04:32 PM, ludovic.desroches@atmel.com :
> From: Ludovic Desroches <ludovic.desroches@atmel.com>
> 
> Create an entry for atmel i2c driver: i2c-at91.c
> 
> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> Hello,
> 
> If there are no objections, I'll take the maintenance of the at91 i2c driver
> since there is no maintainer.

Sure, no objection ;-)
Good luck!

> Wolfram, can you take this patch or do I have to ask someone else?
> 
> Regards
> 
> Ludovic
> 
> 
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9561658..d667ecc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1467,6 +1467,12 @@ F:	drivers/dma/at_hdmac.c
>  F:	drivers/dma/at_hdmac_regs.h
>  F:	include/linux/platform_data/dma-atmel.h
>  
> +ATMEL I2C DRIVER
> +M:	Ludovic Desroches <ludovic.desroches@atmel.com>
> +L:	linux-i2c@vger.kernel.org
> +S:	Supported
> +F:	drivers/i2c/busses/i2c-at91.c
> +
>  ATMEL ISI DRIVER
>  M:	Josh Wu <josh.wu@atmel.com>
>  L:	linux-media@vger.kernel.org
> 


-- 
Nicolas Ferre
