Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3H1GWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:22:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:39468 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab3H1GWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:22:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,974,1367996400"; 
   d="scan'208";a="287699714"
Date: Wed, 28 Aug 2013 11:07:34 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Zhao <rizhao@nvidia.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Richard Zhao <linuxzsc@gmail.com>
Subject: Re: [PATCH] DMA: let filter functions of of_dma_simple_xlate
 possible check of_node
Message-ID: <20130828053734.GH2748@intel.com>
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com>
 <2811939.DFy94j5OEx@avalon>
 <20130826141057.GQ2748@intel.com>
 <3565907.5flGSRLgMJ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3565907.5flGSRLgMJ@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 08:15:17PM +0200, Arnd Bergmann wrote:
> On Monday 26 August 2013 19:40:57 Vinod Koul wrote:
> > And the selection should be done for the cases where you dont have programmable
> > mux in dmac. For programmable ones passing slave_id in dma_slave_config should
> > be fine.
> 
> I think passing a slave_id from the slave driver is never correct with DT,
> since the ID is a property of the system rather than the slave device, so
> the driver has no access to it. Drivers have to always take the settings
> from DT and ignore what dma_slave_config() sets later.
Shouldnt slave id be property of the client driver. That way we can pass it to
the driver using dma_slave_config(). That should make it right..

~Vinod

-- 
