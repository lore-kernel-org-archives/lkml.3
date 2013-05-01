Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144Ab3EACeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 22:34:21 -0400
Received: from tundra.namei.org ([65.99.196.166]:46103 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934061Ab3EACeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 22:34:12 -0400
Date: Wed, 1 May 2013 12:37:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [GIT] Security subsystem updates for 3.10
In-Reply-To: <CA+55aFz2o8i+VnW_S8VBKVkLX1Pw7nQimqm+c6yOQjs-5zE3hA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1305011236040.7261@tundra.namei.org>
References: <alpine.LRH.2.02.1304291237210.6626@tundra.namei.org> <CA+55aFz2o8i+VnW_S8VBKVkLX1Pw7nQimqm+c6yOQjs-5zE3hA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Linus Torvalds wrote:

> On Sun, Apr 28, 2013 at 7:48 PM, James Morris <jmorris@namei.org> wrote:
> >
> > Note: I can't figure out why the patch from Lai Jiangshan shows up twice
> > in the shortlog.  Everything checks out otherwise.
> 
> Because you applied it twice. in two different branches.
> 
> It's there in both your "stage-for-3.10" and "ra-next" branch, commits
> 505f14f7b8d4 and 921f3ac4c3f2 respectively.

I don't have a stage-for-3.10 branch in my tree -- this must have come in 
via the smack tree.


> I would seriously suggest using gitk regularly (limit it to just your
> own stuff with something like "gitk origin.." or whatever) to see the
> history of what you've done visually as often as possible, not only
> does it show up very clearly if you do that, but it really helps to
> have a feel for what you've done.

Thanks.  Will do.



- James
-- 
James Morris
<jmorris@namei.org>
