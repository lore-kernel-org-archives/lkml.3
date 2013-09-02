Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab3IBQ67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:58:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:51069 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab3IBQ66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:58:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1008,1367996400"; 
   d="scan'208";a="354912134"
Date: Mon, 2 Sep 2013 21:42:47 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: dma_slave_caps: remove sg entries
Message-ID: <20130902161247.GA15824@intel.com>
References: <1378124519-13900-1-git-send-email-vinod.koul@intel.com>
 <5224A616.2060501@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5224A616.2060501@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 04:52:06PM +0200, Lars-Peter Clausen wrote:
> On 09/02/2013 02:21 PM, Vinod Koul wrote:
> > As pointed by Russell in [1], the sg properties are already availble in struct device,
> > so no need to duplicate here.
> > 
> > [1]: http://marc.info/?l=linux-omap&m=137416733628831
> 
> Hm, I guess that will work as well, but shouldn't we update the drivers that
> already implementing this interface first?
Well thats why I cced you :). I have fixed up the pl330 driver. Have you used
these values in any of the ASoC drivers?

~Vinod
-- 
