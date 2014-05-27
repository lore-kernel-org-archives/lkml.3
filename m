Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaE0SOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:14:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaE0SOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:14:17 -0400
Date: Tue, 27 May 2014 11:14:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        "Alasdair G. Kergon" <agk@redhat.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] block: flush queued bios when the process
 blocks
Message-ID: <20140527181415.GA8739@infradead.org>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com>
 <5384AA79.4010206@kernel.dk>
 <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
 <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
 <5384CE82.90601@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5384CE82.90601@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 11:42:26AM -0600, Jens Axboe wrote:
> Except such a thing already exists, there are unplug callback
> chains. All I'm asking is that you look into how feasible it would
> be to use something like that, instead of reinventing the wheel.

I suspect the code from MD could be lifted quite easily.

It would be nicer to move it up to the block layer entirely, but when I
tried that a while ago I ran into issues that I unfortunately don't
remember.
