Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbaGNRDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:03:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:22446 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbaGNRD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:03:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="456807035"
Date: Mon, 14 Jul 2014 22:30:31 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH -next 06/26] dma: Use dma_zalloc_coherent
Message-ID: <20140714170031.GB4387@intel.com>
References: <cover.1402863904.git.joe@perches.com>
 <a7ccdeb0ef1861b8f126002dfdbf51ed827478fd.1402863905.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7ccdeb0ef1861b8f126002dfdbf51ed827478fd.1402863905.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 01:37:35PM -0700, Joe Perches wrote:
> Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Applied after updating subsystem name,

Thanks

-- 
~Vinod
