Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3H1Gen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:34:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:16617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab3H1Gem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:34:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,974,1367996400"; 
   d="scan'208";a="387537938"
Date: Wed, 28 Aug 2013 11:19:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] DMA: shdma: fix a bad merge - remove free_irq()
Message-ID: <20130828054917.GI2748@intel.com>
References: <Pine.LNX.4.64.1308261426320.1767@axis700.grange>
 <20130826135308.GP2748@intel.com>
 <Pine.LNX.4.64.1308271028500.11515@axis700.grange>
 <20130827090112.GT2748@intel.com>
 <Pine.LNX.4.64.1308271625560.11515@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1308271625560.11515@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 04:46:51PM +0200, Guennadi Liakhovetski wrote:
> Ok, to me it looks like you did fix some patches in the topic/sh branch, 
> but:
> 
> patch "DMA: shdma: move two macros to a header" is missing
> patch "dma: use dev_get_platdata()" is missing (but ok, it's common for 
> drivers/dma, not sh-specific)
I havent applied that yet, its in my queue..
> patch "shdma: fixup sh_dmae_get_partial() calculation error" is missing
Can you resend these two...?

~Vinod
