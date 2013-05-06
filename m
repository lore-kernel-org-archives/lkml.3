Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3EFHSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:18:11 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:32905 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572Ab3EFHSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:18:10 -0400
Date: Mon, 6 May 2013 12:47:34 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 56/63] ARM: ux500: Remove recently unused
 stedma40_xfer_dir enums
Message-ID: <20130506071733.GA30181@bnru10>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-57-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1367591569-32197-57-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 16:32:42 +0200, Lee Jones wrote:
> We're now using the transfer direction definitions provided by the DMA
> sub-system, so the home-brew ones have become obsolete.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/platform_data/dma-ste-dma40.h |   10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
> index 288dc24..54ddca6 100644
> --- a/include/linux/platform_data/dma-ste-dma40.h
> +++ b/include/linux/platform_data/dma-ste-dma40.h
> @@ -77,14 +77,6 @@ enum stedma40_periph_data_width {
>  	STEDMA40_DOUBLEWORD_WIDTH = STEDMA40_ESIZE_64_BIT
>  };
>  
> -enum stedma40_xfer_dir {
> -	STEDMA40_MEM_TO_MEM = 1,
> -	STEDMA40_MEM_TO_PERIPH,
> -	STEDMA40_PERIPH_TO_MEM,
> -	STEDMA40_PERIPH_TO_PERIPH
> -};
> -
> -
>  /**
>   * struct stedma40_half_channel_info - dst/src channel configuration
>   *
> @@ -120,7 +112,7 @@ struct stedma40_half_channel_info {
>   *
>   */
>  struct stedma40_chan_cfg {
> -	enum stedma40_xfer_dir			 dir;
> +	enum dma_transfer_direction		 dir;


Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>

srinidhi

>  	bool					 high_priority;
>  	bool					 realtime;
>  	enum stedma40_mode			 mode;
> -- 
> 1.7.10.4
> 
