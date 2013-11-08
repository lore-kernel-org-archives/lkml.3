Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3KHP32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:29:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3KHP30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:29:26 -0500
Date: Fri, 8 Nov 2013 08:29:15 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-ID: <20131108152915.GI10212@kernel.dk>
References: <527411DD.7050008@oracle.com>
 <527414DE.9090704@kernel.dk>
 <52756583.2030808@oracle.com>
 <527BE7FA.90904@oracle.com>
 <20131107192545.GA20624@moria.home.lan>
 <527C2AA9.9040608@oracle.com>
 <20131108125307.613427c04a7527c4359e6443@canb.auug.org.au>
 <20131108020805.GI3842@kmo>
 <527C4D35.8000907@oracle.com>
 <20131108073324.GA31662@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108073324.GA31662@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07 2013, Christoph Hellwig wrote:
> Btw, I have to state that I very much disagree with dropping the
> direct I/O kernel changes, and I also very much disagree with keeping
> the immutable iovecs in.
> 
> For the latter I think the immutable iovecs are useful and do want to
> see them eventually, but they were merged at the latest possible point
> in the merge window and cause breakage all over the tree, so they very
> clearly are not ready at this point, and I fear even more breakage if
> they do get merged.

I agree, I've had this very conversation with Kent as well. The merge of
it has gone a lot worse than I had feared, and the resulting series at
this point is a non-bisectable mess. The fallback plan was to pull it
from the 3.13 tree and shove it into a 3.14 tree with more for-next
simmering.

It is in progress, just takes a while...

-- 
Jens Axboe

