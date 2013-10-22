Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3JVLlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:41:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3JVLlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:41:12 -0400
Date: Tue, 22 Oct 2013 04:41:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] block: use a separate plug list for blk-mq requests
Message-ID: <20131022114112.GA22171@infradead.org>
References: <20131006160430.GA5959@infradead.org>
 <20131006181508.GF8252@kernel.dk>
 <20131022061657.GB25870@infradead.org>
 <20131022105106.GH14598@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022105106.GH14598@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 12:51:06PM +0200, Jens Axboe wrote:
> On Mon, Oct 21 2013, Christoph Hellwig wrote:
> > On Sun, Oct 06, 2013 at 12:15:08PM -0600, Jens Axboe wrote:
> > > Thanks, I'll take a look at this. The plugging was done mostly hacky
> > > when implementing it, it was meant to be revisited. So definitely room
> > > for improvement there.
> > 
> > Did you manage to take a look?
> 
> Yep, just did on the flight. I think it looks pretty good and I want to
> queue it up. Did you test it?

Yes, with my usual virtio-blk setup.

