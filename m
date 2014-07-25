Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbaGYInW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:43:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:62341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaGYInR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:43:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="461251301"
Date: Fri, 25 Jul 2014 14:06:58 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: s.hauer@pengutronix.de, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH] dma: imx-sdma: Save imx_dma_data into sdmac
Message-ID: <20140725083658.GJ8181@intel.com>
References: <1402889549-23864-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402889549-23864-1-git-send-email-nicoleotsuka@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:32:29AM +0800, Nicolin Chen wrote:
> The filter() function is currently called by xlate() while it transfers
> imx_dma_data as a local variable to the filter() but releases the data
> right after returning a DMA channel pointer, which results chan->private
> pointing an invalid memory space.
> 
> So this patch just stores the imx_dma_data into sdmac to make usre the
> private pointer valid as long as the channel exists.

Applied, thanks

-- 
~Vinod

