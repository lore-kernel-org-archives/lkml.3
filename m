Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3CUFqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 01:46:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:13144 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab3CUFqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 01:46:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="282583852"
Date: Thu, 21 Mar 2013 10:51:31 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: maxin.john@gmail.com
Cc: djbw@fb.com, lars@metafoo.de, linux-kernel@vger.kernel.org,
        "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH] dma: timb_dma: Fix compiler warning
Message-ID: <20130321052130.GD10326@intel.com>
References: <1361306033-22229-1-git-send-email-maxin.john@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361306033-22229-1-git-send-email-maxin.john@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 10:33:53PM +0200, maxin.john@gmail.com wrote:
> From: "Maxin B. John" <maxin.john@enea.com>
> 
> Fix this compiler warning:
> warning: 'td_remove' defined but not used [-Wunused-function]
> 
> Signed-off-by: Maxin B. John <maxin.john@enea.com>
Applied, thanks

> ---
>  drivers/dma/timb_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
> index 952f823..26107ba 100644
> --- a/drivers/dma/timb_dma.c
> +++ b/drivers/dma/timb_dma.c
> @@ -823,7 +823,7 @@ static struct platform_driver td_driver = {
>  		.owner  = THIS_MODULE,
>  	},
>  	.probe	= td_probe,
> -	.remove	= __exit_p(td_remove),
> +	.remove	= td_remove,
>  };
>  
>  module_platform_driver(td_driver);
> -- 
> 1.7.7
> 
