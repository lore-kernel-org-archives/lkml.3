Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaLHGR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:17:28 -0500
Received: from mga03.intel.com ([134.134.136.65]:36341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaLHGR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:17:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="495266249"
Date: Mon, 8 Dec 2014 11:47:46 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 00/61] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141208061746.GD16827@intel.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:41:54PM +0100, Maxime Ripard wrote:
> Hi,
> 
> As we discussed a couple of weeks ago, this is the third attempt at
> creating a generic behaviour for slave capabilities retrieval so that
> generic layers using dmaengine can actually rely on that.
> 
> That has been done mostly through two steps: by moving out the
> sub-commands of the device_control callback, so that the dmaengine
> core can then infer from that wether a sub-command is implemented, and
> then by moving the slave properties, such as the supported buswidth,
> to the structure dma_device itself.

Okay managed to get this done. Apart from the two issues identified didn't
find anything so applied and pushed to a branch
"topic/slave_caps_device_control_fix"

Today did some compile tests and found few warnings, were trivial but I
am worried about the testing of this code. Has anyone tested this, if so
which platforms are covered Since I pushed base branch last night, Feng's
bot covered it and all was OK. Looks like Feng's bot doesn't have wide
coverage of arm platforms, wasn't there one run by arm guys which tries to
test and boot, if so can we get this tested there please.

So bit sceptical for merging now. I will send the patches which I have
applied on top of this

Thanks
-- 
~Vinod

