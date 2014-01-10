Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbaAJCg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:36:59 -0500
Received: from tundra.namei.org ([65.99.196.166]:51479 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbaAJCg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:36:57 -0500
Date: Fri, 10 Jan 2014 13:36:59 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        stable <stable@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
In-Reply-To: <CA+55aFwVNAKAqyR8gA+pewz2qSjDCq2w+NwN-vmChoMKSz-idg@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1401101336320.7164@tundra.namei.org>
References: <20140109162731.12500986@gandalf.local.home> <20140109214239.GD29910@parisc-linux.org> <20140109165012.391db81e@gandalf.local.home> <20140109223127.GM10323@ZenIV.linux.org.uk> <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
 <20140109182523.5b50131f@gandalf.local.home> <20140109182756.17abaaa8@gandalf.local.home> <1389310626.15209.92.camel@localhost> <CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com> <20140110000642.GN10323@ZenIV.linux.org.uk>
 <CA+55aFwVNAKAqyR8gA+pewz2qSjDCq2w+NwN-vmChoMKSz-idg@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014, Linus Torvalds wrote:

> > There's an extra source of headache, BTW - what about the "LSM stacking"
> > crowd and their plans?
> 
> LSM stacking is a pipedream right  now anyway, isn't it? It's been
> talked about for years and years, I've never seen a patch-set that is
> even remotely something we'd seriously consider.
> 

And there's no good justification for it.


-- 
James Morris
<jmorris@namei.org>
