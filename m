Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3HZOhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:37:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:4629 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab3HZOhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:37:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="368606318"
Date: Mon, 26 Aug 2013 19:23:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH] DMA: shdma: fix a bad merge - remove free_irq()
Message-ID: <20130826135308.GP2748@intel.com>
References: <Pine.LNX.4.64.1308261426320.1767@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1308261426320.1767@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 02:27:51PM +0200, Guennadi Liakhovetski wrote:
> A bad merge resulted in a left-over free_irq() call. This patch removes it.
Applied, thanks

Can you also test this branch and see if anything is remaining

And can you take care then ARM patches in last serries are merged this week...

~Vinod
