Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab3KLFqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 00:46:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:22735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3KLFqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 00:46:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433669345"
Date: Tue, 12 Nov 2013 10:21:05 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Simon <horms@verge.net.au>, Max Filippov <max.filippov@cogentembedded.com>,
        Magnus <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] rcar-hpbdma: fixup patches for double plane
Message-ID: <20131112045105.GG8834@intel.com>
References: <87k3hc189h.wl%kuninori.morimoto.gx@renesas.com>
 <87eh747eoj.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh747eoj.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:51:28PM -0700, Kuninori Morimoto wrote:
> 
> Hi Vinod
> Cc: Simon, Max
> 
> These patches fixup R-Car HBPDMA driver
> for double plane.
> 
> I tested these patches on my R-Car sound driver in local environment.
> It doesn't work without these patches.
Applied, thanks

--
~Vinod

> 
> Kuninori Morimoto (3):
>       rcar-hpbdma: add max transfer size
>       rcar-hpbdma: initialise plane information when halted
>       rcar-hpbdma: fixup channel busy check for double plane
> 
>  drivers/dma/sh/rcar-hpbdma.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> 
> Best regards
> ---
> Kuninori Morimoto

-- 
