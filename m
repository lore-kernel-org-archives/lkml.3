Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaI2Iid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:38:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:40217 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaI2Iic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:38:32 -0400
Message-ID: <54291A84.5080109@atmel.com>
Date: Mon, 29 Sep 2014 10:38:28 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>, <computersforpeace@gmail.com>,
        <akpm@linux-foundation.org>
CC: <linux-mtd@lists.infradead.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] MAINTAINERS: add atmel nand driver maintainer entry
References: <1411979763-1449-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1411979763-1449-1-git-send-email-josh.wu@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/2014 10:36, Josh Wu :
> This patch adds an entry in MAINTAINERS file for ATMEL nand driver.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3705430..1bdf3bf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1698,6 +1698,12 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  S:	Supported
>  F:	drivers/net/ethernet/cadence/
>  
> +ATMEL NAND DRIVER
> +M:	Josh Wu <josh.wu@atmel.com>
> +L:	linux-mtd@lists.infradead.org
> +S:	Supported
> +F:	drivers/mtd/nand/atmel_nand*
> +
>  ATMEL SPI DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  S:	Supported
> 


-- 
Nicolas Ferre
