Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3HZOfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:35:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:37952 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab3HZOfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:35:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="393524244"
Date: Mon, 26 Aug 2013 19:20:38 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Dan Williams'" <djbw@fb.com>,
        linux-kernel@vger.kernel.org,
        "'Simon Horman'" <horms+renesas@verge.net.au>
Subject: Re: [PATCH] dma: sh: remove unnecessary platform_set_drvdata()
Message-ID: <20130826135038.GO2748@intel.com>
References: <002801ce9e53$2f63b1e0$8e2b15a0$%han@samsung.com>
 <Pine.LNX.4.64.1308261134240.1767@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1308261134240.1767@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 02:38:17PM +0200, Guennadi Liakhovetski wrote:
> On Wed, 21 Aug 2013, Jingoo Han wrote:
> 
> > The driver core clears the driver data to NULL after device_release
> > or on probe failure. Thus, it is not needed to manually clear the
> > device driver data to NULL.
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> This has to be updated on top of current 
> http://git.infradead.org/users/vkoul/slave-dma.git next branch, there it 
> will patch the drivers/dma/sh/shdmac.c file, not drivers/dma/sh/shdma.c. 
> After that feel free to add my
He already updated & i have applied...
> 
> Acked-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
added...

~Vinod
