Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaCMQOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:14:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbaCMQOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:14:24 -0400
Date: Thu, 13 Mar 2014 12:13:47 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140313161347.GA6598@redhat.com>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312102849.GA26509@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12 2014 at  6:28am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Mar 08, 2014 at 08:51:18PM +0100, Hannes Reinecke wrote:
> > Hey, calm down.
> > I've made the fix just two days ago. And was quite surprised that
> > I've been the first hitting that; should've crashed for everybody
> > using dm-multipath.
> > And given the pushback I've gotten recently from patches I would
> > have thought that it would work for most users; sure the author
> > would've done due diligence on the original patchset ...
> 
> There's very little testing of dm-multipath for upstream work, as I've
> seen tons of avoidable breakage.  Doesn't help that it uses a special
> code path that one else uses.

Pretty ironic that in the same email that you ask someone to "Let's make
this a little less personal." you start by asserting upstream
dm-multipath sees very little testing -- and use your commit that
recently broke dm-multipath as the basis.  Anyway, please exapnd on what
you feel is broken with upstream dm-multipath.

And please be specific about whether it is SCSI/block or dm-multipath
code that has regressed.

> > BTW, it not _my_ decision to sit on tons of SUSE specific patches.
> > I really try to get things upstream. But I cannot do more than
> > sending patches upstream, answer patiently any questions, and redo
> > the patchset.
> > Which I did. Frequently, But, alas, it's up to the maintainer to
> > apply them. And I can only ask and hope. The usual story...
> 
> Let's make this a little less personal.  Fact is that the SuSE trees
> have tons of patches in there that never have even been sent upstream.
> There's also tons that have been posted once or twice.  While I feel
> your frustration with the SCSI process fully and we'll need to work on
> that somehow, how about you do another round of dumping the DM patches
> on the dm-devel list and Mike?
> 
> I'll ping some of the other worst offenders as time permits.
> 
