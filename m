Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaLOIPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:15:48 -0500
Received: from mga03.intel.com ([134.134.136.65]:59117 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaLOIPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:15:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,578,1413270000"; 
   d="scan'208";a="623838379"
Date: Mon, 15 Dec 2014 13:45:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Asaf Vertz <asaf.vertz@tandemg.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: imx-sdma: fix indentation
Message-ID: <20141215081553.GO16827@intel.com>
References: <20141210080035.GA25812@ubuntu>
 <20141211045006.GI16827@intel.com>
 <5489466B.5080901@tandemg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5489466B.5080901@tandemg.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 09:23:23AM +0200, Asaf Vertz wrote:
> On 12/11/2014 06:50 AM, Vinod Koul wrote:
> > On Wed, Dec 10, 2014 at 10:00:36AM +0200, Asaf Vertz wrote:
> >> Fixed a coding style error, switch and case should be at the same indent
> > Please use the right subsystem name for the patches
> 
> what subsystem name I should have used?
> I used the one from the last patches in the log
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/drivers/dma/imx-sdma.c

$ git llog drivers/dma/pl330.c | grep "dma: pl" |wc -l
22
$ git log drivers/dma/pl330.c | grep "dmaengine: pl" |wc -l
32

and these are last commits

$ git log --oneline drivers/dma/pl330.c
046209f61b5f dmaengine: pl330: update author info
cee42392f5f0 dmaengine: pl330: Correct device assignment.
6e4a2a83f958 dmaengine: pl330: Fix NULL pointer dereference on driver unbind
0f5ebabdd03b dmaengine: pl330: Fix NULL pointer dereference on probe failure
c3cb38f43cb9 dmaengine: pl330: Remove unused 'regs' variable in pl330_submit_req()
937cb2f2498d dmaengine: pl330: Remove non-NULL check for pl330_submit_req parameters
31c1e5a1350a dmaengine: Remove the context argument to the prep_dma_cyclic operation
b1e51d771fbc dmaengine: pl330: Check if the DMA descriptor is NULL
c26939e5204c dmaengine: pl330: Remove pl330_chan_ctrl()
8ed30a14265f dmaengine: pl330: Simplify marking a request as unused
9dc5a315fe51 dmaengine: pl330: Embed pl330_req directly into dma_pl330_desc
f6f2421c0a1c dmaengine: pl330: Merge dma_pl330_dmac and pl330_dmac structs
fbbcd9be96a0 dmaengine: pl330: Simplify is_manager()

-- 
~Vinod
