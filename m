Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaEBRCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:02:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:34506 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbaEBRCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:02:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="532593959"
Date: Fri, 2 May 2014 22:19:32 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, leo.li@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/8] DMA: Freescale: add fsl_dma_free_descriptor()
 to reduce code duplication
Message-ID: <20140502164932.GF32284@intel.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-5-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397809071-5353-5-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 04:17:47PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> There are several places where descriptors are freed using identical code.
> This patch puts this code into a function to reduce code duplication.
> 
Applied, thanks

-- 
~Vinod
