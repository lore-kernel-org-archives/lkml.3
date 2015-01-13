Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbbAMRhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:37:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:21228 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbbAMRhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:37:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="440056772"
Date: Tue, 13 Jan 2015 23:05:32 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH RESEND] dmaengine: drop owner assignment from
 platform_drivers
Message-ID: <20150113173532.GA15411@intel.com>
References: <1421167621-24786-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421167621-24786-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 05:46:48PM +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
Applied, thanks

-- 
~Vinod
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
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
