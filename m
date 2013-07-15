Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab3GOLCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:02:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:8786 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab3GOLCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="331506166"
Date: Mon, 15 Jul 2013 15:53:33 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Matt Porter <matt@ohporter.com>
Subject: Re: [PATCH] dmaengine: add dma_slave_get_caps api
Message-ID: <20130715102332.GS16653@intel.com>
References: <1373273650-31097-1-git-send-email-vinod.koul@intel.com>
 <1373882236-9566-1-git-send-email-vinod.koul@intel.com>
 <51E3D463.3040200@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E3D463.3040200@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 12:52:19PM +0200, Lars-Peter Clausen wrote:
> On 07/15/2013 11:57 AM, Vinod Koul wrote:
> > add new device callback .device_slave_caps api which can be used by clients to
> > query the dma channel capablties before they program the channel. This can help
> > is removing errors during the channel programming. Also add helper
> > dma_slave_get_caps API
> > 
> > This patch folds the work done by Matt earlier
> > https://patchwork.kernel.org/patch/2094891/
> > 
> > Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> > --
> > this version
> > 	changes api to include struct dma_slave_caps as arg
> > 	removed burst lengths, can be added when we have users
> 
> Hi,
> 
> it looks like you did send out v1 by accident.
Yes but problem wasnt sending wrong patch but generating patch without
comitting!

resent now...

I am planning to keep this on a branch which I wont rebase. That way users
(mostly ASoC for now), can merge this and get drivers converted.

~Vinod
