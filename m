Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaA0TQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:16:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36425 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaA0TQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:16:57 -0500
Date: Mon, 27 Jan 2014 12:16:56 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ipi_redirect vs rq_affinity
Message-ID: <20140127191656.GD2782@kernel.dk>
References: <20140124132234.GA8553@infradead.org>
 <20140124191129.GG7483@kernel.dk>
 <20140127075158.GB18590@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127075158.GB18590@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26 2014, Christoph Hellwig wrote:
> On Fri, Jan 24, 2014 at 11:11:29AM -0800, Jens Axboe wrote:
> > It is pretty much the same. I don't like the semantics of the old one,
> > where it's 0/1/2 for off/on/different-on, though. Seems like now would
> > be a good time to clean it up.
> 
> I don't think arbitrarily breaking this fairly widely used interface
> when a driver is moving to blk-mq sounds like a good idea.  Maybe we
> should allow for setting descriptive strings as well?

Yeah, that's a good idea. We could retain the 0/1/2 for compat reasons,
but have it present strings instead.

> Also the different on semantics do matter for some use cases, and we
> should support both for blk-mq.

Certainly, not disagreeing with that.

-- 
Jens Axboe

