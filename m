Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbaDVQVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:21:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:51419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765AbaDVQUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:20:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,904,1389772800"; 
   d="scan'208";a="525507360"
Date: Tue, 22 Apr 2014 21:39:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joel Fernandes <joelf@ti.com>
Cc: dan.j.williams@intel.com, nsekhar@ti.com, dmaengine@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: edma: Add DMA memcpy support
Message-ID: <20140422160930.GY32284@intel.com>
References: <1397875833-31345-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397875833-31345-1-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 09:50:33PM -0500, Joel Fernandes wrote:
> We add DMA memcpy support to EDMA driver. Successful tests performed using
> dmatest kernel module. Copy alignment is set to DMA_SLAVE_BUSWIDTH_4_BYTES and
> users must ensure length is aligned so that copy is performed fully.

Applied, thanks

-- 
~Vinod
