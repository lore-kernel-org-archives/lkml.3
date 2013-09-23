Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3IWFK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 01:10:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:32287 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab3IWFKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 01:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,960,1371106800"; 
   d="scan'208";a="399546701"
Date: Mon, 23 Sep 2013 09:49:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Christoph Fritz <chf.fritz@googlemail.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [[PATCH] 0/3] imx-dma: fixes
Message-ID: <20130923041953.GA17188@intel.com>
References: <1379426168-31989-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379426168-31989-1-git-send-email-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 03:56:05PM +0200, Michael Grzeschik wrote:
> Hello,
> 
> this series is solving some lockdep issues in the imx-dma code.
> There are some list_head and deadlock issues in the code,
> that is running the implementation into unsafe situations.
Thanks for this, I have trying to fix this with testing done by Christoph. I had
similar set of fixes

Christoph can you pls try runnning this on your setup and check and we can apply
these

~Vinod
> 
> Regards,
> Michael
> 
> Michael Grzeschik (3):
>   dma: imx-dma: fix slow path issue in prep_dma_cyclic
>   dma: imx-dma: fix lockdep issue between irqhandler and tasklet
>   dma: imx-dma: fix callback path in tasklet
> 
>  drivers/dma/imx-dma.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> -- 
> 1.8.4.rc3
> 

-- 
