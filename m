Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaD1L3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:29:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbaD1L3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:29:11 -0400
Date: Mon, 28 Apr 2014 04:29:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] random: export add_disk_randomness
Message-ID: <20140428112908.GB2808@infradead.org>
References: <20140425073610.GA2143@infradead.org>
 <20140425073637.GB2143@infradead.org>
 <20140425134951.GF11124@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425134951.GF11124@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 09:49:51AM -0400, Theodore Ts'o wrote:
> On Fri, Apr 25, 2014 at 12:36:37AM -0700, Christoph Hellwig wrote:
> > This will be needed for pending changes to the scsi midlayer that now calls
> > lower level block APIs, as well as any blk-mq driver that wants to contribute
> > to the random pool.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Jens, can you pull this into the block tree for me?
