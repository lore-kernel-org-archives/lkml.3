Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3EPHS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:18:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:36676 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab3EPHSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:18:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="338150895"
Date: Thu, 16 May 2013 12:12:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 10/39] dmaengine: ste_dma40: Correct copy/paste error
Message-ID: <20130516064217.GH14863@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-11-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368611522-9984-11-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:51:33AM +0100, Lee Jones wrote:
> 'struct stedma40_half_channel_info's header comment says that it's
> called 'struct stedma40_chan_cfg'. Let's straighten that out.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
>  include/linux/platform_data/dma-ste-dma40.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
> index af0064e..288dc24 100644
> --- a/include/linux/platform_data/dma-ste-dma40.h
> +++ b/include/linux/platform_data/dma-ste-dma40.h
> @@ -86,7 +86,7 @@ enum stedma40_xfer_dir {
>  
>  
>  /**
> - * struct stedma40_chan_cfg - dst/src channel configuration
> + * struct stedma40_half_channel_info - dst/src channel configuration
>   *
>   * @big_endian: true if the src/dst should be read as big endian
>   * @data_width: Data width of the src/dst hardware
> -- 
> 1.7.10.4
> 
