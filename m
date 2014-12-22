Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaLVPii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:38:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:48287 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbaLVPig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:38:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,624,1413270000"; 
   d="scan'208";a="651679712"
Date: Mon, 22 Dec 2014 21:08:22 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH 06/28] dma: drop owner assignment from platform_drivers
Message-ID: <20141222153822.GP16827@intel.com>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-7-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419196495-9626-7-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 10:14:27PM +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
After susbstem name if fixed

Acked-by: Vinod Koul <vinod.koul@intel.com>

-- 
~Vinod

> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.
> 
>  drivers/dma/at_xdmac.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
> index b60d77a22df6..1c4c96b7e2bf 100644
> --- a/drivers/dma/at_xdmac.c
> +++ b/drivers/dma/at_xdmac.c
> @@ -1507,7 +1507,6 @@ static struct platform_driver at_xdmac_driver = {
>  	.remove		= at_xdmac_remove,
>  	.driver = {
>  		.name		= "at_xdmac",
> -		.owner		= THIS_MODULE,
>  		.of_match_table	= of_match_ptr(atmel_xdmac_dt_ids),
>  		.pm		= &atmel_xdmac_dev_pm_ops,
>  	}
> -- 
> 2.1.3
> 

-- 
