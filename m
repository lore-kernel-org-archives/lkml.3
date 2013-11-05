Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3KEJtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:49:32 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3KEJta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:49:30 -0500
Date: Tue, 5 Nov 2013 01:49:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the staging tree with the block tree
Message-ID: <20131105094926.GA12440@infradead.org>
References: <20131105160924.4da55b7e36aa2ab93443fdda@canb.auug.org.au>
 <20131105052010.GA14557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105052010.GA14557@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 09:20:10PM -0800, Greg KH wrote:
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> 
> Looks good to me, thanks.

The lloop driver should simply be dropped.  It's a duplication of loop
which had some lustre-specific hacks that are replaced with generic
improvements already in linux-next.

