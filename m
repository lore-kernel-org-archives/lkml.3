Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaKLJbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:31:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:33326 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbaKLJbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:31:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,367,1413270000"; 
   d="scan'208";a="630667639"
Date: Wed, 12 Nov 2014 15:01:58 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jon Medhurst <tixy@linaro.org>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] dma: pl330: Fixes for DMA memcpy
Message-ID: <20141112093158.GB24582@intel.com>
References: <1415383518-29327-1-git-send-email-tixy@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415383518-29327-1-git-send-email-tixy@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 06:05:16PM +0000, Jon Medhurst wrote:
> This is a couple of patches I produced when trying to get dmatest to run
> with the pl330 driver. The second one is actually a theoretical fix
> because the FIFO on the platform I was using is too large for the tests
> to hit the limit, but the datasheet says the device can lockup if all
> the FIFO entries are exhausted, so it seems like a sensible precaution.
>
Applied, thanks

Please ensure you use the right subsystem name for the patch header

-- 
~Vinod
