Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3JQIJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 04:09:06 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:23546 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3JQII6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:08:58 -0400
Message-ID: <525F9B14.8080106@atmel.com>
Date: Thu, 17 Oct 2013 10:08:52 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <g.liakhovetski@gmx.de>,
        <linux@arm.linux.org.uk>
Subject: Re: [PATCH 03/28] dmaengine: at_hdma: use DMA_COMPLETE for dma completion
 status
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com> <1381940926-25564-4-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1381940926-25564-4-git-send-email-vinod.koul@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/2013 18:28, Vinod Koul :
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> CC: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/dma/at_hdmac.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index c787f38..1ef7457 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1102,7 +1102,7 @@ atc_tx_status(struct dma_chan *chan,
>   	int bytes = 0;
>
>   	ret = dma_cookie_status(chan, cookie, txstate);
> -	if (ret == DMA_SUCCESS)
> +	if (ret == DMA_COMPLETE)
>   		return ret;
>   	/*
>   	 * There's no point calculating the residue if there's
>


-- 
Nicolas Ferre
