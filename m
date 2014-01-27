Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaA0HwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:52:00 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaA0Hv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:51:58 -0500
Date: Sun, 26 Jan 2014 23:51:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ipi_redirect vs rq_affinity
Message-ID: <20140127075158.GB18590@infradead.org>
References: <20140124132234.GA8553@infradead.org>
 <20140124191129.GG7483@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124191129.GG7483@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 11:11:29AM -0800, Jens Axboe wrote:
> It is pretty much the same. I don't like the semantics of the old one,
> where it's 0/1/2 for off/on/different-on, though. Seems like now would
> be a good time to clean it up.

I don't think arbitrarily breaking this fairly widely used interface
when a driver is moving to blk-mq sounds like a good idea.  Maybe we
should allow for setting descriptive strings as well?

Also the different on semantics do matter for some use cases, and we
should support both for blk-mq.

