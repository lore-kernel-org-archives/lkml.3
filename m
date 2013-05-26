Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3EZEza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 00:55:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:55349 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab3EZEz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 00:55:29 -0400
Date: Sun, 26 May 2013 15:03:25 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: Stupid VFS name lookup interface..
In-Reply-To: <20130525165710.GC25399@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.2.02.1305261500410.7712@tundra.namei.org>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com> <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com> <20130525165710.GC25399@ZenIV.linux.org.uk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 May 2013, Al Viro wrote:

> Well...   The problem I see here is not even selinux per se - it's that
> "LSM stacking" insanity.

FWIW, I don't see a concrete rationale for merging this stacking work. That 
doesn't mean there won't be one in the future, but I wouldn't let the idea 
of a future possible change prevent this patch from being merged.




-- 
James Morris
<jmorris@namei.org>
