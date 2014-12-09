Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbaLIJYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:24:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:62845 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbaLIJYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:24:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,543,1413270000"; 
   d="scan'208";a="650814943"
Date: Tue, 9 Dec 2014 14:54:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dmaengine@vger.kernel.org
Subject: Re: [RESEND PATCH] ioatdma, fix dma mapping errors
Message-ID: <20141209092424.GC16827@intel.com>
References: <1414064309-22232-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414064309-22232-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 07:38:29AM -0400, Prarit Bhargava wrote:
> This happens because the current ioatdma DMA test code does not check the return
> value of dma_map_page() calls with dma_mapping_error().  In addition, it was
> noticed that mapping for the variable dest_dma is free'd before the last use.
> 
> This patch fixes these errors by initializing the dma_srcs[] array and checking
> the returns with dma_mapping_error().
Please make sure you use the right subsystem name

Applied now, thanks

-- 
~Vinod

