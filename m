Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3LRQnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:43:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:25150 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3LRQnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:43:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="452083489"
Date: Wed, 18 Dec 2013 21:14:48 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dmaengine@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 1/2] drivers: dma: Mark functions as static in dma_v3.c
Message-ID: <20131218154448.GD16227@intel.com>
References: <dba654dc34646dda2998dbf7b08d7ce3c160ff8c.1387188138.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dba654dc34646dda2998dbf7b08d7ce3c160ff8c.1387188138.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 03:40:40PM +0530, Rashika Kheria wrote:
> Mark the functions ioat3_prep_xor_val(), ioat3_prep_pq_val() and
> ioat3_prep_pqxor_val() as static in dma_v3.c because they are not used
> outside this file.
> 
> This eliminates the following warnings in dma_v3.c:
> drivers/dma/ioat/dma_v3.c:741:1: warning: no previous prototype for ‘ioat3_prep_xor_val’ [-Wmissing-prototypes]
> drivers/dma/ioat/dma_v3.c:1092:1: warning: no previous prototype for ‘ioat3_prep_pq_val’ [-Wmissing-prototypes]
> drivers/dma/ioat/dma_v3.c:1134:1: warning: no previous prototype for ‘ioat3_prep_pqxor_val’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
