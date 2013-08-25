Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3HYIT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 04:19:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:6727 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab3HYITy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 04:19:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,950,1367996400"; 
   d="scan'208";a="368083154"
Date: Sun, 25 Aug 2013 13:05:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH 0/3] DMA: shdma: several stylistic improvements and
 support for new SoCs
Message-ID: <20130825073525.GD8091@intel.com>
References: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 05:45:49PM +0200, Guennadi Liakhovetski wrote:
> Hi
> 
> The first two patches in this small series improve driver internals a bit 
> by using preferred APIs, the 3rd patch adds support for new DMAC versions, 
> present on AG5, APE6, H2.
Applied, thanks

Although the patch 1 didnt apply for me :( I have manually remove a hunk, I dont
which tree yoy genertaed this agaisnt!

~Vinod
