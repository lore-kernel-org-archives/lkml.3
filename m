Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3JOAm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:42:58 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45241 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab3JOAm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:42:57 -0400
Date: Tue, 15 Oct 2013 09:42:47 +0900
From: Simon Horman <horms@verge.net.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] rcar-hpbdma: remove shdma_free_irq() calls
Message-ID: <20131015004247.GK22321@verge.net.au>
References: <201309260228.37765.sergei.shtylyov@cogentembedded.com>
 <20131011015502.GD2954@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011015502.GD2954@intel.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 07:25:02AM +0530, Vinod Koul wrote:
> On Thu, Sep 26, 2013 at 02:28:37AM +0400, Sergei Shtylyov wrote:
> > Commit c1c63a14f4f2419d093acd7164eccdff315baa86 (DMA: shdma: switch to managed
> > resource allocation) got rid of shdma_free_irq() but  unfortunately got merged
> > later than commit c4f6c41ba790bbbfcebb4c47a709ac8ff1fe1af9 (dma: add driver for
> > R-Car HPB-DMAC), so that the HPB-DMAC driver retained the calls and got broken:
> > 
> > drivers/dma/sh/rcar-hpbdma.c: In function `hpb_dmae_alloc_chan_resources':
> > drivers/dma/sh/rcar-hpbdma.c:435: error: implicit declaration of function
> > `shdma_free_irq'
> > 
> > Fix this compilation error by removing the remaining shdma_free_irq() calls.
> > 
> > Reported-by: Simon Horman <horms@verge.net.au>
> > Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Applied both, Thanks

Thanks!
