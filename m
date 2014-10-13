Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaJMNIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:08:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbaJMNIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:08:01 -0400
From: Paul Moore <pmoore@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT] Security subsystem upate for 3.18
Date: Mon, 13 Oct 2014 09:07:53 -0400
Message-ID: <6097685.yy4GYjPioe@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <alpine.LRH.2.11.1410131502510.6957@namei.org>
References: <alpine.LRH.2.11.1410101913460.13164@namei.org> <CA+55aFxtxBe8SaEYD6vAQME_YE+eD6mhU8F6Q850k-XBfzz4QQ@mail.gmail.com> <alpine.LRH.2.11.1410131502510.6957@namei.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 13, 2014 03:06:34 PM James Morris wrote:
> On Sun, 12 Oct 2014, Linus Torvalds wrote:
> > on some previous development, so it's often a good time to simply
> > create a new feature branch. I don't know how James feels about
> > merging multiple separate feature branches, but I know that *I* tend
> > to appreciate it when I get multiple well-defined pull requests rather
> > than one big one that does many different things.
> 
> It's fine with me.
> 
> This is the first time I saw (or noticed) that Paul had back merged ahead
> of me, but it seemed to merge into my tree ok so I didn't query it at the
> time.

The management of the linux-security tree, the approach I was taking with the 
SELinux tree, and the approach that the other LSM maintainers use has been 
discussed many times on the LSM list.  I'm also fairly certain that you were 
on the To/CC line for many, if not all, of those threads.

-- 
paul moore
security and virtualization @ redhat

