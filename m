Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaJNLCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:02:09 -0400
Received: from tundra.namei.org ([65.99.196.166]:50424 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbaJNLCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:02:07 -0400
Date: Tue, 14 Oct 2014 22:01:52 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Paul Moore <pmoore@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT] Security subsystem upate for 3.18
In-Reply-To: <6097685.yy4GYjPioe@sifl>
Message-ID: <alpine.LRH.2.11.1410142155360.27774@namei.org>
References: <alpine.LRH.2.11.1410101913460.13164@namei.org> <CA+55aFxtxBe8SaEYD6vAQME_YE+eD6mhU8F6Q850k-XBfzz4QQ@mail.gmail.com> <alpine.LRH.2.11.1410131502510.6957@namei.org> <6097685.yy4GYjPioe@sifl>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2014, Paul Moore wrote:

> On Monday, October 13, 2014 03:06:34 PM James Morris wrote:
> > On Sun, 12 Oct 2014, Linus Torvalds wrote:
> > > on some previous development, so it's often a good time to simply
> > > create a new feature branch. I don't know how James feels about
> > > merging multiple separate feature branches, but I know that *I* tend
> > > to appreciate it when I get multiple well-defined pull requests rather
> > > than one big one that does many different things.
> > 
> > It's fine with me.
> > 
> > This is the first time I saw (or noticed) that Paul had back merged ahead
> > of me, but it seemed to merge into my tree ok so I didn't query it at the
> > time.
> 
> The management of the linux-security tree, the approach I was taking with the 
> SELinux tree, and the approach that the other LSM maintainers use has been 
> discussed many times on the LSM list.  I'm also fairly certain that you were 
> on the To/CC line for many, if not all, of those threads.
> 

My expectation is that people develop against my next branch, per the 
documentation here:

http://kernsec.org/wiki/index.php/Kernel_Repository

What we agreed to recently is that I'll sync to Linus' releases, as 
several devlopers need/want to work with more recent kernels.  I had been 
only syncing to Linus as necessary (e.g. to get in sync with say the 
mainline modules code for key subsystem updates).

It's possible I missed something in the threads and we have a 
misunderstanding about this process.


-- 
James Morris
<jmorris@namei.org>

