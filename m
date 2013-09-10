Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3IJWjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:39:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59331 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3IJWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:39:38 -0400
Date: Tue, 10 Sep 2013 23:39:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20130910223935.GD13318@ZenIV.linux.org.uk>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
 <20130910152753.662599171456233c5f91edb4@linux-foundation.org>
 <20130910222924.GB13318@ZenIV.linux.org.uk>
 <20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
 <20130910223624.GC13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910223624.GC13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:36:24PM +0100, Al Viro wrote:
> On Tue, Sep 10, 2013 at 03:35:20PM -0700, Andrew Morton wrote:
> > On Tue, 10 Sep 2013 23:29:24 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > On Tue, Sep 10, 2013 at 03:27:53PM -0700, Andrew Morton wrote:
> > > 
> > > > This is rather a fiasco.  "vfs: reorganize dput() memory accesses" made
> > > > rather a mess of a 46 patch series which has been under development and
> > > > test for two cycles so far.
> > > 
> > > Check vfs.git#for-next...
> > 
> > Why?  What is in it?
> 
> Initial attempt to port that very thing on top of current mainline.

... with considerable breakage around "dcache: convert to use new lru list
infrastructure", indeed.  I'll see what I can do there...
