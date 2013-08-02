Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3HBBGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:06:23 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:21016 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037Ab3HBBGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:06:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFANkE+1F5LPxHgWdsb2JhbABbhjK2d4UwgRsXDgEBFiYogiQBAQIDOhwjEAgDDgQGCSUPBSUDDRQTiA+6OhaPcQeEDAOXXoojilUq
Date: Fri, 2 Aug 2013 11:06:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        jack@suse.cz, glommer@parallels.com
Subject: Re: [PATCH 08/11] inode: convert per-sb inode list to a list_lru
Message-ID: <20130802010616.GS7118@dastard>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-9-git-send-email-david@fromorbit.com>
 <20130801081950.GA18828@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801081950.GA18828@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 01:19:50AM -0700, Christoph Hellwig wrote:
> At this point the list_lru name really becomes confusing.  Given that
> it's not really LRU specific maybe just rename it to pernode_list
> or similar?

Well, such things were suggested when the list_lru was first
proposed. Indeed, it even lived in lib/ because I saw it as widely
useful. But akpm didn't like it because of the "structure with
internal locking" architecture and thought it was too purpose
specific for generic use and so it got moved uot of lib/ into mm/
and here we are.

I don't care for how it's named, located or used - I just want to be
able to use the infrastructure it provides. As such renaming and
relocating it is not something I'm about to do in this specific
patchset....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
