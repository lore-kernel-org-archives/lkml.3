Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3LRQpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:45:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:9018 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab3LRQo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:44:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="426706024"
Date: Wed, 18 Dec 2013 21:15:16 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        dmaengine@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 2/2] drivers: dma: Include appropriate header file in
 dca.c
Message-ID: <20131218154516.GE16227@intel.com>
References: <dba654dc34646dda2998dbf7b08d7ce3c160ff8c.1387188138.git.rashika.kheria@gmail.com>
 <855c6e216e86bed7b723c1a647491d9fab2ed77b.1387188138.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <855c6e216e86bed7b723c1a647491d9fab2ed77b.1387188138.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 03:44:39PM +0530, Rashika Kheria wrote:
> Includes an appropriate header file dma_v2.h in ioat/dca.c because
> functions ioat2_dca_init() and ioat3_dca_init() have their function
> declarations in dma_v2.h.
> 
> This eliminates the following warning in ioat/dca.c:
> drivers/dma/ioat/dca.c:410:22: warning: no previous prototype for ‘ioat2_dca_init’ [-Wmissing-prototypes]
> drivers/dma/ioat/dca.c:624:22: warning: no previous prototype for ‘ioat3_dca_init’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod

> ---
>  drivers/dma/ioat/dca.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
> index 9e84d5b..b158bba 100644
> --- a/drivers/dma/ioat/dca.c
> +++ b/drivers/dma/ioat/dca.c
> @@ -35,6 +35,7 @@
>  
>  #include "dma.h"
>  #include "registers.h"
> +#include "dma_v2.h"
>  
>  /*
>   * Bit 7 of a tag map entry is the "valid" bit, if it is set then bits 0:6
> -- 
> 1.7.9.5
> 

-- 
