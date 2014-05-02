Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaEBRCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:02:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:31314 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbaEBRCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:02:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="525051598"
Date: Fri, 2 May 2014 22:19:05 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, leo.li@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/8] DMA: Freescale: remove attribute DMA_INTERRUPT
 of dmaengine
Message-ID: <20140502164905.GE32284@intel.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-4-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397809071-5353-4-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 04:17:46PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Delete attribute DMA_INTERRUPT because fsldma doesn't support this function,
> exception will be thrown if talitos is used to offload xor at the same time.
> 
Applied, thanks

-- 
~Vinod
