Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaLIJQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:16:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:44427 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbaLIJPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:15:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="426823187"
Date: Tue, 9 Dec 2014 14:46:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: dan.j.williams@intel.com, lars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, padma.kvr@gmail.com
Subject: Re: [PATCH v2 0/2] dma: pl330: improve status checking
Message-ID: <20141209091609.GB16827@intel.com>
References: <1417767955-5480-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417767955-5480-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 09:25:53AM +0100, Robert Baldyga wrote:
> Hi,
> 
> This series allows to check DMA transfer residue (number of bytes left
> to send/receive) by modifying pl330_tx_status() function, when struct
> dma_tx_state is filled with needed data. It also introduces DMA_PAUSE
> feature, which allows to halt DMA transfer before termination and read
> residue without risk of data loss.
> 
> This features are needed for proper implementation of DMA transfers,
> particulary for serial drivers when transfer sizes are unknown and
> requests on DMA channels are terminated before transfer completion
> very ofter (it's becouse we terminate then in timeout interrupt to
> avoid latency which is usually undesirable).
Applied, thanks

-- 
~Vinod

