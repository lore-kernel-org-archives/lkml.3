Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3HYIS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 04:18:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:4729 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab3HYISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 04:18:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,950,1367996400"; 
   d="scan'208";a="386124903"
Date: Sun, 25 Aug 2013 13:04:20 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH] DMA: shdma: fix CHCLR register address calculation
Message-ID: <20130825073420.GC8091@intel.com>
References: <Pine.LNX.4.64.1307021733280.1965@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1307021733280.1965@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 05:37:58PM +0200, Guennadi Liakhovetski wrote:
> struct sh_dmae_device::chan_reg is a pointer to u32, therefore when adding
> offsets to it care should be taken to add offsets in sizeof(u32) units, not
> in bytes. This patch corrects such a bug. While at it we also remove the
> redundant parameter of the affected function.
Applied, thanks

~Vinod
