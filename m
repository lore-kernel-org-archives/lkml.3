Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3HZIeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:34:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:61520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab3HZIeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:34:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,956,1367996400"; 
   d="scan'208";a="368456500"
Date: Mon, 26 Aug 2013 13:19:13 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Simon Horman <horms@verge.net.au>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v5 0/7] DMA: shdma: switch DT to use OF device ID tables
Message-ID: <20130826074913.GI2748@intel.com>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
 <20130825073656.GF8091@intel.com>
 <20130826071725.GJ26682@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826071725.GJ26682@verge.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 04:17:25PM +0900, Simon Horman wrote:
> On Sun, Aug 25, 2013 at 01:06:57PM +0530, Vinod Koul wrote:
> > On Fri, Aug 02, 2013 at 04:50:35PM +0200, Guennadi Liakhovetski wrote:
> > > In this version of shdma Device Tree support I preserved the DT 
> > > configuration approach via OF device ID tables from v4, but now it is only 
> > > used for the DT-mode, the C-version is left untouched. In this series I 
> > > only include one platform: r8a73a4-based APE6EVM, if accepted, others can 
> > > be added easily. I also took care not to include mach/*.h headers in 
> > > driver .c files. To illustrate the use of DT DMA support for MMC DMA on 
> > > APE6EVM a patch from a previously separate patch series "DMA for MMCIF and 
> > > SDHI devices in DT mode"
> > I have applied all the dma patches, the ARM ones fail for me so should possible
> > go thru ARM tree.
> 
> Guennadi, if you need me to queue up any patches please repost them
> once their dependencies are available in a stable branch.
I think Guennadi is on vacation, so can someone queue up the ARM patches and
mierge them thru ARM tree...

~Vinod
-- 
