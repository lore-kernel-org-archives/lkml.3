Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3IBHQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:16:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:64278 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262Ab3IBHQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:16:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1005,1367996400"; 
   d="scan'208";a="354722376"
Date: Mon, 2 Sep 2013 12:00:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: imx-sdma: Staticize sdma_driver_data structures
Message-ID: <20130902063024.GH7376@intel.com>
References: <1378083432-15728-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378083432-15728-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 09:57:12PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Sparse report the following warnings:
> 
> drivers/dma/imx-sdma.c:330:25: warning: symbol 'sdma_imx31' was not declared. Should it be static?
> drivers/dma/imx-sdma.c:351:25: warning: symbol 'sdma_imx25' was not declared. Should it be static?
> drivers/dma/imx-sdma.c:357:25: warning: symbol 'sdma_imx35' was not declared. Should it be static?
> drivers/dma/imx-sdma.c:375:25: warning: symbol 'sdma_imx51' was not declared. Should it be static?
> drivers/dma/imx-sdma.c:395:25: warning: symbol 'sdma_imx53' was not declared. Should it be static?
> drivers/dma/imx-sdma.c:414:25: warning: symbol 'sdma_imx6q' was not declared. Should it be static?
> 
> Make the sdma_driver_data structures static.
Applied, thanks

~Vinod
