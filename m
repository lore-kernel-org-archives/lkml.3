Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab3EZE4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 00:56:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:55356 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab3EZE4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 00:56:12 -0400
Date: Sun, 26 May 2013 15:04:08 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: Stupid VFS name lookup interface..
In-Reply-To: <CA+55aFw1RLrMsvkG+yHfHw4ht5BcC7Q39qXDD2dyUp9+_HsSLA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1305261503510.7712@tundra.namei.org>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com> <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com> <20130525165710.GC25399@ZenIV.linux.org.uk> <51A1040A.80003@schaufler-ca.com>
 <CA+55aFw1RLrMsvkG+yHfHw4ht5BcC7Q39qXDD2dyUp9+_HsSLA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 May 2013, Linus Torvalds wrote:

> But I haven't even looked at what non-selinux setups do to
> performance. Last time I tried Ubuntu (they still use apparmor, no?),
> "make modules_install ; make install" didn't work for the kernel, and
> if the Ubuntu people don't want to support kernel engineers, I
> certainly am not going to bother with them. Who uses smack?

Tizen, perhaps a few others.


-- 
James Morris
<jmorris@namei.org>
