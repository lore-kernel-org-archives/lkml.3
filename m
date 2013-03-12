Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3CLEKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:10:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:38943 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab3CLEKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:10:02 -0400
Date: Tue, 12 Mar 2013 15:10:53 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: unneeded merge in the security tree
In-Reply-To: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
Message-ID: <alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Mar 2013, Stephen Rothwell wrote:

> Hi all,
> 
> [James, I am not picking on you, just using your tree to illustrate a
> point.]
> 
> The top commit in the security tree today is a merge of v3.9-rc2.  This
> is a completely unnecessary merge as the tree before the merge was a
> subset of v3.9-rc1 and so if the merge had been done using anything but
> the tag, it would have just been a fast forward.  I know that this is now
> deliberate behaviour on git's behalf, but isn't there some way we can
> make this easier on maintainers who are just really just trying to pick a
> new starting point for their trees after a release?  (at least I assume
> that is what James was trying to do)

Yes, and I was merging to a tag as required by Linus.


-- 
James Morris
<jmorris@namei.org>
