Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbaJMEGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 00:06:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:50414 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaJMEGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 00:06:47 -0400
Date: Mon, 13 Oct 2014 15:06:34 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paul Moore <pmoore@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT] Security subsystem upate for 3.18
In-Reply-To: <CA+55aFxtxBe8SaEYD6vAQME_YE+eD6mhU8F6Q850k-XBfzz4QQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.1410131502510.6957@namei.org>
References: <alpine.LRH.2.11.1410101913460.13164@namei.org> <CA+55aFwGpnBgSeyjKQuwKwSpccTHvQwPJGEXfw2wx9LJ-kafTg@mail.gmail.com> <18599898.QtEUVscf6i@sifl> <CA+55aFwwB1uUnUKdQq28T-3AgVcwPSJR27HnTDnrCyD4xowUOQ@mail.gmail.com>
 <CA+55aFxtxBe8SaEYD6vAQME_YE+eD6mhU8F6Q850k-XBfzz4QQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2014, Linus Torvalds wrote:

> on some previous development, so it's often a good time to simply
> create a new feature branch. I don't know how James feels about
> merging multiple separate feature branches, but I know that *I* tend
> to appreciate it when I get multiple well-defined pull requests rather
> than one big one that does many different things.

It's fine with me.

This is the first time I saw (or noticed) that Paul had back merged ahead 
of me, but it seemed to merge into my tree ok so I didn't query it at the 
time.

Paul: it's likey best if you consider my -next branch as your upstream.  
I'll sync to Linus on point releases as previously discussed.

Linus: sorry about all of this, and I'll ensure there's always a summary 
of the changes and a correct subject for you.



-- 
James Morris
<jmorris@namei.org>

