Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbaGYJKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:10:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:36890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759665AbaGYJKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="578820426"
Date: Fri, 25 Jul 2014 14:33:45 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: jz4740: Fix GPL v2 license string typo
Message-ID: <20140725090345.GP8181@intel.com>
References: <20140715232438.24028.90309.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715232438.24028.90309.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 05:24:38PM -0600, Bjorn Helgaas wrote:
> Per license_is_gpl_compatible(), the MODULE_LICENSE() string for GPL v2 is
> "GPL v2", not "GPLv2".  Use "GPL v2" so this module doesn't taint the
> kernel.

Applied, thanks

-- 
~Vinod

> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/dma/dma-jz4740.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/dma-jz4740.c b/drivers/dma/dma-jz4740.c
> index 94c380f07538..bfbce6b07902 100644
> --- a/drivers/dma/dma-jz4740.c
> +++ b/drivers/dma/dma-jz4740.c
> @@ -614,4 +614,4 @@ module_platform_driver(jz4740_dma_driver);
>  
>  MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
>  MODULE_DESCRIPTION("JZ4740 DMA driver");
> -MODULE_LICENSE("GPLv2");
> +MODULE_LICENSE("GPL v2");
> 

-- 
