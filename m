Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaBJKdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:33:17 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaBJKdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:33:16 -0500
Date: Mon, 10 Feb 2014 02:33:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140210103315.GB28396@infradead.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <20140207011827.GA4735@kernel.org>
 <20140207141915.GA24176@infradead.org>
 <20140208005507.GA1766@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208005507.GA1766@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 08:55:07AM +0800, Shaohua Li wrote:
> Yep, none driver needs it. But reverse mapping is the one of the points we use
> tag, so better we prepare it.

I don't think adding unused code to tree for a future driver is a good
idea, although I'm happy to help out with the functionality as soon
as the need arrives.

In the meantime we really need something like this fix to allow
non-trivial drivers to use blk-mq.
