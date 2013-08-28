Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3H1RYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:24:08 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49825 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752829Ab3H1RYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:24:05 -0400
X-Sasl-enc: eS5OLz6QV/JTHLmyep7Fw8wrRU8ZmmbcPZMPhN0GVWBI 1377710638
Date: Wed, 28 Aug 2013 10:26:18 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: linux-next: manual merge of the dma-mapping tree with the
 driver-core tree
Message-ID: <20130828172618.GC5012@kroah.com>
References: <20130828170503.de07a17bcd5994a7434477da@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828170503.de07a17bcd5994a7434477da@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 05:05:03PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the dma-mapping tree got a conflict in
> drivers/base/dma-contiguous.c between commit cebcac7c59e8 ("drivers /
> dma-contiguous: Fix __init attribute location") from the driver-core tree
> and commit a2547380393a ("drivers: dma-contiguous: clean source code and
> prepare for device tree") from the dma-mapping tree.
> 
> I fixed it up (the latter is a superset of the former, so I used that)
> and can carry the fix as necessary (no action is required).

Sounds good, thanks.

greg k-h
