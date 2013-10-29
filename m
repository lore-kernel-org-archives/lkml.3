Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3J2HIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:08:18 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56688 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3J2HIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:08:16 -0400
Date: Tue, 29 Oct 2013 16:08:13 +0900
From: Simon Horman <horms@verge.net.au>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Max Filippov <max.filippov@cogentembedded.com>,
        Magnus <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] rcar-hpbdma: fixup patches for double plane
Message-ID: <20131029070811.GA19861@verge.net.au>
References: <87k3hc189h.wl%kuninori.morimoto.gx@renesas.com>
 <87eh747eoj.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh747eoj.wl%kuninori.morimoto.gx@renesas.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> 
> Kuninori Morimoto (3):
>       rcar-hpbdma: add max transfer size
>       rcar-hpbdma: initialise plane information when halted
>       rcar-hpbdma: fixup channel busy check for double plane
> 
>  drivers/dma/sh/rcar-hpbdma.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Thanks Morimoto-san,

these all look good to me.

Acked-by: Simon Horman <horms+renesas@verge.net.au>


Vinod, could you consider applying these?
