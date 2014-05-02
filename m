Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaEBRBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:01:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:20666 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbaEBRBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:01:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="533742317"
Date: Fri, 2 May 2014 22:18:47 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, leo.li@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/8] DMA: Freescale: unify register access methods
Message-ID: <20140502164847.GD32284@intel.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-3-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397809071-5353-3-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 04:17:45PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Methods of accessing DMA controller registers are inconsistent, some registers
> are accessed by DMA_IN/OUT directly, while others are accessed by functions
> get/set_* which are wrappers of DMA_IN/OUT, and even for the BCR register, it
> is read by get_bcr but written by DMA_OUT.
> This patch unifies the inconsistent methods, all registers are accessed by
> get/set_* now.
> 
Applied, thanks

-- 
~Vinod
