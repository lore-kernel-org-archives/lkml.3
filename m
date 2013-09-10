Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3IJW7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:59:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59359 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3IJW7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:59:42 -0400
Date: Tue, 10 Sep 2013 23:59:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20130910225934.GF13318@ZenIV.linux.org.uk>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
 <20130910152753.662599171456233c5f91edb4@linux-foundation.org>
 <20130910222924.GB13318@ZenIV.linux.org.uk>
 <20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
 <20130910223624.GC13318@ZenIV.linux.org.uk>
 <20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
 <20130910224823.GE13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910224823.GE13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:48:23PM +0100, Al Viro wrote:
> On Tue, Sep 10, 2013 at 03:41:16PM -0700, Andrew Morton wrote:
> 
> > Obtained from where?  There are a whole pile of fixes resulting from
> > review and linux-next testing.  Are they included?
> 
> -next and yes.  The trivial ones - folded into the commits they are fixing
> (I mean, ones directly following the commit being fixed).  The rest included
> as individual commits.
> 
> I'm looking through the DCACHE_LRU_LIST mess right now...

It's not that bad, actually; I think the variant I've pushed right now
(vfs.git#for-next, head at f5e1dd34561e0fb06400b378d595198918833021) should
be doing the right thing.  It ought to cover everything in your branch
in -next from "fs: bump inode and dentry counters to long" on to the
end of queue.
