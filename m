Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaGaMHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:07:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:40936 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaGaMHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:07:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,771,1400050800"; 
   d="scan'208";a="463547823"
Date: Thu, 31 Jul 2014 17:28:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: nsekhar@ti.com, joelf@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] dmaengine: edma: Do not change the error code
 returned from edma_alloc_slot
Message-ID: <20140731115817.GR8181@intel.com>
References: <1406801558-13126-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406801558-13126-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 01:12:37PM +0300, Peter Ujfalusi wrote:
> In case of edma_alloc_slot() failure during probe we should return the error
> unchanged to make debugging easier.

Applied both

Thanks

-- 
~Vinod

