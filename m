Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3KMPMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:12:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:47070 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab3KMPMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:12:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434640006"
Date: Wed, 13 Nov 2013 19:46:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 01/13] dma: ste_dma40: Expand DT binding to accept
 'high-priority channel' flag
Message-ID: <20131113141630.GC8834@intel.com>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
 <1383732985-18928-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383732985-18928-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:16:13AM +0000, Lee Jones wrote:
> This is used for MSP (audio) devices which is about to be fully DT:ed.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
> ---
>  Documentation/devicetree/bindings/dma/ste-dma40.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/dma/ste-dma40.txt b/Documentation/devicetree/bindings/dma/ste-dma40.txt
> index a8c21c2..1f5729f 100644
> --- a/Documentation/devicetree/bindings/dma/ste-dma40.txt
> +++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
> @@ -50,6 +50,9 @@ Each dmas request consists of 4 cells:
>          0x00000008: Use fixed channel:
>                  Use automatic channel selection when unset
>                  Use DMA request line number when set
> +        0x00000010: Set channel as high priority:
> +                Normal priority when unset
> +                High priority when set
>  
>  Example:
>  
> -- 
> 1.8.1.2
> 

-- 
