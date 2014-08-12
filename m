Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaHLVyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:54:00 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7613 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbaHLVx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:53:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiwKAFSM6lN5LDJ8/2dsb2JhbABagw1SV65JAQEBAQEBBp5WgWWFawGBFhd3hAQBBTocIxAIAw4KCSUPBSUDIROIQcU4FxiFZIlQB4RMAQSVQ4Z1gViTJ4NuKy8
Date: Wed, 13 Aug 2014 07:53:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [GIT PULL] xfs: updates for 3.17-rc1
Message-ID: <20140812215344.GY20518@dastard>
References: <20140812125313.GX20518@dastard>
 <20140812235612.684a9af7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812235612.684a9af7@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 11:56:12PM +1000, Stephen Rothwell wrote:
> Hi Dave,
> 
> On Tue, 12 Aug 2014 22:53:13 +1000 Dave Chinner <david@fromorbit.com> wrote:
> >
> > FYI, this will be the last pull request I will send you from a tree
> > on oss.sgi.com. I'm moving everything XFS related over to kernel.org
> > so future pull requests should come from there.
> 
> Please let me know when you have the new tree set up so I can change
> where I fetch from.

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git for-next

It should be identical to the xfs tree you are pulling from
oss.sgi.com.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
