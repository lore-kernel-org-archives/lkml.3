Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab3JYFRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 01:17:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:30784 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab3JYFRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 01:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="398371596"
Date: Fri, 25 Oct 2013 09:53:10 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
Message-ID: <20131025042310.GC21230@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
 <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
 <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
 <20131017020745.GA14013@intel.com>
 <20131017142755.GA4477@breakpoint.cc>
 <20131017134846.GG14013@intel.com>
 <Pine.LNX.4.64.1310242326500.2900@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1310242326500.2900@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 11:28:29PM +0200, Guennadi Liakhovetski wrote:
> Hi Vinod
> 
> On Thu, 17 Oct 2013, Vinod Koul wrote:
> > Yes i missed it in first place update the patch to fix that
> 
> Are you planning to post a fixed version of this patch or you just fix it 
> internally? Would be good to have it posted to be able to ack it and other 
> relevant patches.
looks like you missed it... I had posted updated patch [1] in this thread here
and I posted 29th patch as removal one [2]

Both were pushed to -next after few days

[1]: http://marc.info/?l=linux-kernel&m=138197886521699&w=2
[2]: http://marc.info/?l=linux-kernel&m=138197936321767&w=2

-- 
~Vinod
