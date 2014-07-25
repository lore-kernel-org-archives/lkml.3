Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbaGYI70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:59:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:30437 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaGYI7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:59:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="548880560"
Date: Fri, 25 Jul 2014 14:23:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: Remove unused definition of DMA_MAX_COOKIE
Message-ID: <20140725085306.GO8181@intel.com>
References: <1405095506-14865-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405095506-14865-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:18:26PM +0200, Geert Uytterhoeven wrote:
> As of commit commit f04cd40701deace2efb9edd7120e59366bda2118 ("fsldma: fix
> controller lockups"), its last (and only ever) user is gone.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied, thanks

-- 
~Vinod

> ---
>  include/linux/dmaengine.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 3d1c2aa51530..16e829034ae9 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -37,7 +37,6 @@
>   */
>  typedef s32 dma_cookie_t;
>  #define DMA_MIN_COOKIE	1
> -#define DMA_MAX_COOKIE	INT_MAX
>  
>  static inline int dma_submit_error(dma_cookie_t cookie)
>  {
> -- 
> 1.9.1
> 

-- 
