Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbbAMSUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:20:24 -0500
Received: from mga03.intel.com ([134.134.136.65]:53408 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbAMSUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:20:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="650540933"
Date: Tue, 13 Jan 2015 23:49:15 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] dmaengine: mxs-dma: Declare slave capabilities for the
 generic code
Message-ID: <20150113181915.GF15411@intel.com>
References: <1419873679-14463-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419873679-14463-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 03:21:19PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Since ecc19d17868be9c ("dmaengine: Add a warning for drivers not using the
> generic slave caps retrieval") the following warning is observed:
> 
> [    0.113023] ------------[ cut here ]------------
> [    0.113053] WARNING: CPU: 0 PID: 1 at drivers/dma/dmaengine.c:830 dma_async_device_register+0x2a0/0x4c8()
> [    0.113063] this driver doesn't support generic slave capabilities reporting
> 
> Declare the slave capabilities to avoid such warning.
Applied, thanks

-- 
~Vinod
