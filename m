Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaFDOUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:20:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaFDOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:20:14 -0400
Date: Wed, 4 Jun 2014 07:20:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140604142012.GA20056@infradead.org>
References: <20140509120733.GA27918@kernel.org>
 <20140509150018.GA26215@infradead.org>
 <20140510040023.GA13788@kernel.org>
 <5388912F.7010609@kernel.dk>
 <20140604111133.GA7826@infradead.org>
 <538F2A11.4060800@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F2A11.4060800@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 08:15:45AM -0600, Jens Axboe wrote:
> Alright, I'll revert it to pass in the tags instead.

It's not as simple as the added code wants to get a queue from the
hwctx, which we can't get at.  I was planning to look into this, but
there are various other regressions in the recent block updates that I
need to fix before I can even test a tree with this one reverted.

If you can get to sorting this out soon I'd love you to handle it,
otherwise I'll look into it as soon as I can.

