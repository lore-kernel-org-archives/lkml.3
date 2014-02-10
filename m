Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaBJQQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:16:35 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaBJQQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:16:31 -0500
Date: Mon, 10 Feb 2014 08:16:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
Message-ID: <20140210161619.GB8570@infradead.org>
References: <20131231033827.GA31994@kernel.org>
 <20140104210804.GA24199@kmo-pixel>
 <20140105131300.GB4186@kernel.org>
 <20140106204641.GB9037@kmo>
 <52CB1783.4050205@kernel.dk>
 <20140106214726.GD9037@kmo>
 <20140209155006.GA16149@dhcp-26-207.brq.redhat.com>
 <20140210103211.GA28396@infradead.org>
 <20140210122942.GB320@dhcp-26-207.brq.redhat.com>
 <20140210154917.GC320@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210154917.GC320@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:49:17PM +0100, Alexander Gordeev wrote:
> > Do we really always need the pool for these classes of devices?
> > 
> > Pulling tags from local caches to the pool just to (near to) dry it at
> > the very next iteration does not seem beneficial. Not to mention caches
> > vs pool locking complexities.
> 
> And I meant here we do not scrap per cpu allocations.

I'm still a bit confused at what you're proposing.  Part of the problem
might be that I'm not exactly familar with the allocator and am just
looking it from a consumer perspective.

