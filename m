Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3JVLzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:55:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50785 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab3JVLzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:55:15 -0400
Date: Tue, 22 Oct 2013 13:55:11 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] block: use a separate plug list for blk-mq requests
Message-ID: <20131022115511.GJ14598@kernel.dk>
References: <20131006160430.GA5959@infradead.org>
 <20131006181508.GF8252@kernel.dk>
 <20131022061657.GB25870@infradead.org>
 <20131022105106.GH14598@kernel.dk>
 <20131022114112.GA22171@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022114112.GA22171@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22 2013, Christoph Hellwig wrote:
> On Tue, Oct 22, 2013 at 12:51:06PM +0200, Jens Axboe wrote:
> > On Mon, Oct 21 2013, Christoph Hellwig wrote:
> > > On Sun, Oct 06, 2013 at 12:15:08PM -0600, Jens Axboe wrote:
> > > > Thanks, I'll take a look at this. The plugging was done mostly hacky
> > > > when implementing it, it was meant to be revisited. So definitely room
> > > > for improvement there.
> > > 
> > > Did you manage to take a look?
> > 
> > Yep, just did on the flight. I think it looks pretty good and I want to
> > queue it up. Did you test it?
> 
> Yes, with my usual virtio-blk setup.

Excellent, just wanted to be sure before I pushed anything out, since I
can't test personally on the road...

-- 
Jens Axboe

