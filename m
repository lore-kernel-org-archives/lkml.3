Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3AOJVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 04:21:05 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50798 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756676Ab3AOJVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 04:21:00 -0500
Message-ID: <1358241656.2383.2.camel@dabdike.int.hansenpartnership.com>
Subject: Re: Bcache v. whatever
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        snitzer@redhat.com
Date: Tue, 15 Jan 2013 09:20:56 +0000
In-Reply-To: <20130114223202.GV26407@google.com>
References: <20130114223202.GV26407@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 14:32 -0800, Kent Overstreet wrote:
> Bcache: a block layer SSD cache
> 
> Does writethrough and writeback, handles unclean shutdown, and has
> various other nifty features. See the wiki and the documentation for
> more:
> 
> http://bcache.evilpiepirate.org
> 
> Over the Christmas break I finally got the tree into a self contained
> state that ought to be suitable for merging; this tree is fairly close
> to the previous stable tree that people have been running on production
> servers for awhile (and that I've been running on this workstation), 
> 
> So, I think this is ready for mainline and I'd like to get it in. I
> should've tried to push it ages ago, but I was hoping to get in various
> block layer cleanups first; I finally deided to work around them in the
> meantime since I haven't had time to finish the block layer stuff.
> 
> Not everything has been addressed since I last posted for review
> feedback - notably the closure code was controversial and for now I've
> just moved that into drivers/block/bcache (though I've been refactoring
> stuff to make it less asynchronous lately; most of that work is in the
> testing/dev branches). The bigger issue IMO is the userspace interface -
> I'd like to finish the md integration so it doesn't need userspace stuff
> for probing/bootup. So, I'd be fine with it going into staging if that's
> the consensus, but it's stable tested code.
> 
> The code is available at
> http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream
> 
> This latest branch is on top of v3.8-rc3:

The guy to merge this is the maintainer in that layer, which is Alasdair
Kergon.  I know you've been sending patches to the dm-devel list, what's
the reason you didn't include him in the cc list?  Is there some type of
political problem in dm?  From reading the list, it looks like your
patches are being tested and progressing, so what am I missing?

James


