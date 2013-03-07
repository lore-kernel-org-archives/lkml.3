Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3CGG7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:59:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:60968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab3CGG7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:59:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,800,1355126400"; 
   d="scan'208";a="210253686"
Date: Thu, 7 Mar 2013 12:04:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] of: dma: make #dma-cells optional
Message-ID: <20130307063426.GF13370@intel.com>
References: <1362013078-2213-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362013078-2213-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 06:57:57PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> For controllers with no requests/clients (memory to memory only), the
Change log is truncated...

> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  Documentation/devicetree/bindings/dma/dma.txt |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/dma/dma.txt b/Documentation/devicetree/bindings/dma/dma.txt
> index 8f504e6..d388f06 100644
> --- a/Documentation/devicetree/bindings/dma/dma.txt
> +++ b/Documentation/devicetree/bindings/dma/dma.txt
> @@ -8,9 +8,10 @@ controller.
>  * DMA controller
>  
>  Required property:
> -- #dma-cells: 		Must be at least 1. Used to provide DMA controller
> -			specific information. See DMA client binding below for
> -			more details.
> +- #dma-cells: 		Required for controllers with requests. Optional for
> +			memory to memory only DMA controllers. Must be at least
> +			1. Used to provide DMA controller specific information. 
> +			See DMA client binding below for more details.
>  
>  Optional properties:
>  - dma-channels: 	Number of DMA channels supported by the controller.
> -- 
> 1.7.10.4
> 
