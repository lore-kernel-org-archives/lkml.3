Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3KENGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:06:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44157 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607Ab3KENGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:06:19 -0500
X-Sasl-enc: yq2GulZs7L0ntLV6W5hxLHoPzu2MuWH6deHXSWv24WSk 1383656779
Date: Tue, 5 Nov 2013 05:08:33 -0800
From: Greg KH <greg@kroah.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the staging tree with the block tree
Message-ID: <20131105130833.GC19906@kroah.com>
References: <20131105160924.4da55b7e36aa2ab93443fdda@canb.auug.org.au>
 <20131105052010.GA14557@kroah.com>
 <20131105094926.GA12440@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105094926.GA12440@infradead.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 01:49:26AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 04, 2013 at 09:20:10PM -0800, Greg KH wrote:
> > > I fixed it up (see below) and can carry the fix as necessary (no action
> > > is required).
> > 
> > Looks good to me, thanks.
> 
> The lloop driver should simply be dropped.  It's a duplication of loop
> which had some lustre-specific hacks that are replaced with generic
> improvements already in linux-next.

That's fine with me, I figure it will be deleted eventually by someone
sending me a patch to do so...
