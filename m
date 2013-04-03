Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774Ab3DCLdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:33:07 -0400
Received: from fieldses.org ([174.143.236.118]:44911 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761667Ab3DCLdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:33:04 -0400
Date: Wed, 3 Apr 2013 07:33:01 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (nfsd
 tree related)
Message-ID: <20130403113301.GA13951@fieldses.org>
References: <20130403174219.0786d27109633a30d89b38bf@canb.auug.org.au>
 <20130403071054.45a02a88@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403071054.45a02a88@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 07:10:54AM -0400, Jeff Layton wrote:
> On Wed, 3 Apr 2013 17:42:19 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (arm defconfig)
> > failed like this:
> > 
> > fs/built-in.o: In function `nfsd_reply_cache_stats_show':
> > super.c:(.text+0x87308): undefined reference to `__udivdi3'
> > 
> > Probably caused by commit 187da2f90879 ("nfsd: keep track of the max and
> > average time to search the cache") which adds a divide by u64
> > (num_searches).
> > 
> > I have reverted that commit and the following one for today.
> 
> Thanks, known problem...
> 
> Looks like Bruce's tree has an older version of that patch series. I
> think we just need to get him to drop that one and merge the new one.

Arrgh, sorry--could you remind me which is the new one?

--b.
