Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaHDIsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:48:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:50674 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbaHDIsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,796,1400050800"; 
   d="scan'208";a="571343683"
Date: Mon, 4 Aug 2014 14:08:23 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Vignesh Raman <Vignesh_Raman@mentor.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiada_Wang@mentor.com
Subject: Re: [PATCH 1/2] dma: imx-sdma: use module_platform_driver for SDMA
 driver
Message-ID: <20140804083823.GO8181@intel.com>
References: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com>
 <1406725875-9171-2-git-send-email-Vignesh_Raman@mentor.com>
 <20140731120011.GS8181@intel.com>
 <53DF471D.70407@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DF471D.70407@mentor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 02:11:01PM +0530, Vignesh Raman wrote:
> On Thursday 31 July 2014 05:30 PM, Vinod Koul wrote:
> > On Wed, Jul 30, 2014 at 06:41:14PM +0530, Vignesh Raman wrote:
> >> Currently there is no module_exit declared in SDMA driver, so that once
> >> sdma module is inserted, it's shown with permanent attribute by lsmod,
> >> and it can't be removed.
> >> Use module_platform_driver to register/unregister SDMA driver and modify
> >> SDMA's remove operation, to make SDMA driver possible to be removed.
> > where is this bit below?
> > 
> I'm not clear with your question. Are you asking about the unregister
> SDMA driver function? It is done by dma_async_device_unregister.
Driver already uses module_platform_driver, so I dont see what information
the last two lines are trying to convey.

Patch needs to talk about what is done in current patch

-- 
~Vinod

