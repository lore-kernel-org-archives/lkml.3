Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3LPKVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:21:54 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39364 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3LPKVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:21:52 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 16 Dec 2013 02:21:42 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers: dma: Include appropriate header file in
 dca.c
Message-ID: <20131216102142.GB22119@leaf>
References: <dba654dc34646dda2998dbf7b08d7ce3c160ff8c.1387188138.git.rashika.kheria@gmail.com>
 <855c6e216e86bed7b723c1a647491d9fab2ed77b.1387188138.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <855c6e216e86bed7b723c1a647491d9fab2ed77b.1387188138.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
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

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

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
