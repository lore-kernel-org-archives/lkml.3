Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaEBRDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:03:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:61420 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaEBRDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:03:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="426870976"
Date: Fri, 2 May 2014 22:20:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, leo.li@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/8] DMA: Freescale: move functions to avoid forward
 declarations
Message-ID: <20140502165005.GG32284@intel.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-6-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397809071-5353-6-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 04:17:48PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> These functions will be modified in the next patch in the series. By moving the
> function in a patch separate from the changes, it will make review easier.
>
Applied, thanks

-- 
~Vinod
