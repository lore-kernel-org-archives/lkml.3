Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaDATTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:19:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaDATTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:19:21 -0400
Date: Tue, 1 Apr 2014 12:19:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        chenhanxiao <chenhanxiao@cn.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
Message-Id: <20140401121920.50d1dd96c2145acc81561b82@linux-foundation.org>
In-Reply-To: <533A5CB1.1@jp.fujitsu.com>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	<20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
	<1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>
	<20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
	<1396308332.18499.25.camel@buesod1.americas.hpqcorp.net>
	<20140331170546.3b3e72f0.akpm@linux-foundation.org>
	<533A5CB1.1@jp.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2014 15:29:05 +0900 Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> >
> > So their system will act as if they had set SHMMAX=enormous.  What
> > problems could that cause?
> >
> >
> > Look.  The 32M thing is causing problems.  Arbitrarily increasing the
> > arbitrary 32M to an arbitrary 128M won't fix anything - we still have
> > the problem.  Think bigger, please: how can we make this problem go
> > away for ever?
> >
> 
> Our middleware engineers has been complaining about this sysctl limit.
> System administrator need to calculate required sysctl value by making sum
> of all planned middlewares, and middleware provider needs to write "please
> calculate systcl param by....." in their installation manuals.

Why aren't people just setting the sysctl to a petabyte?  What problems
would that lead to?
