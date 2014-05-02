Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaEBRBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:01:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:17676 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaEBRBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:01:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="532593016"
Date: Fri, 2 May 2014 22:18:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, leo.li@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/8] DMA: Freescale: remove the unnecessary
 FSL_DMA_LD_DEBUG
Message-ID: <20140502164826.GC32284@intel.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-2-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397809071-5353-2-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 04:17:44PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Some codes are calling chan_dbg with FSL_DMA_LD_DEBUG surrounded, it is really
> unnecessary to use such a macro because chan_dbg is a wrapper of dev_dbg, we do
> have corresponding DEBUG macro to switch on/off dev_dbg, and most of the other
> codes are also calling chan_dbg directly without using FSL_DMA_LD_DEBUG.
>
Applied, thanks

-- 
~Vinod
 
