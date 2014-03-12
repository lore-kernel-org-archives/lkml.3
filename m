Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaCLK2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:28:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCLK2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:28:53 -0400
Date: Wed, 12 Mar 2014 03:28:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        msnitzer <msnitzer@redhat.com>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140312102849.GA26509@infradead.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531B74B6.4070004@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 08:51:18PM +0100, Hannes Reinecke wrote:
> Hey, calm down.
> I've made the fix just two days ago. And was quite surprised that
> I've been the first hitting that; should've crashed for everybody
> using dm-multipath.
> And given the pushback I've gotten recently from patches I would
> have thought that it would work for most users; sure the author
> would've done due diligence on the original patchset ...

There's very little testing of dm-multipath for upstream work, as I've
seen tons of avoidable breakage.  Doesn't help that it uses a special
code path that one else uses.

> BTW, it not _my_ decision to sit on tons of SUSE specific patches.
> I really try to get things upstream. But I cannot do more than
> sending patches upstream, answer patiently any questions, and redo
> the patchset.
> Which I did. Frequently, But, alas, it's up to the maintainer to
> apply them. And I can only ask and hope. The usual story...

Let's make this a little less personal.  Fact is that the SuSE trees
have tons of patches in there that never have even been sent upstream.
There's also tons that have been posted once or twice.  While I feel
your frustration with the SCSI process fully and we'll need to work on
that somehow, how about you do another round of dumping the DM patches
on the dm-devel list and Mike?

I'll ping some of the other worst offenders as time permits.

