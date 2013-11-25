Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3KYTqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:46:40 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24580 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3KYTqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:46:36 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Kq631cXhenG3BUYpxiLtnyc79+U6zIiI=
Date: Mon, 25 Nov 2013 14:46:31 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: mv_xor: remove mv_desc_get_dest_addr()
Message-ID: <20131125194631.GE2879@titan.lakedaemon.net>
References: <1385408365-8072-1-git-send-email-jason@lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385408365-8072-1-git-send-email-jason@lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 07:39:25PM +0000, Jason Cooper wrote:
> The following commit:
> 
>   54f8d501e842 dmaengine: remove DMA unmap from drivers
> 
> removed the last caller to mv_desc_get_dest_addr(), creating the
> warning:
> 
>   drivers/dma/mv_xor.c:57:12: warning: 'mv_desc_get_dest_addr' defined
>   but not used [-Wunused-function]
> 
> Remove it.
> 
> Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> ---
>  drivers/dma/mv_xor.c | 6 ------
>  1 file changed, 6 deletions(-)

Gah!  I sent too fast.  I meant to mention that I have this in my
mvebu/fixes branch, which gets merged into -next each night.  (The
warning was bugging me :) )

Just let me know when you take it and I'll drop it from my branches.

thx,

Jason.
