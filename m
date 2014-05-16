Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbaEPQVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:21:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459AbaEPQVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:21:21 -0400
Date: Fri, 16 May 2014 12:20:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, namhyung@gmail.com, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/6] events, perf: Pass protection and flags bits through
 mmap2 interface
Message-ID: <20140516162025.GZ50500@redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-2-git-send-email-dzickus@redhat.com>
 <20140516122219.GQ11096@twins.programming.kicks-ass.net>
 <20140516133300.GO50500@redhat.com>
 <20140516154538.GW11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516154538.GW11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 05:45:38PM +0200, Peter Zijlstra wrote:
> On Fri, May 16, 2014 at 09:33:00AM -0400, Don Zickus wrote:
> > On Fri, May 16, 2014 at 02:22:19PM +0200, Peter Zijlstra wrote:
> > > On Tue, May 13, 2014 at 12:48:12PM -0400, Don Zickus wrote:
> > > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > 
> > > > The mmap2 interface was missing the protection and flags bits needed to
> > > > accurately determine if a mmap memory area was shared or private and
> > > > if it was readable or not.
> > > > 
> > > > [tweaked patch to compile and wrote changelog]
> > > > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > > > 
> > > > --
> > > > Peter you mentioned writing up a changelog for this patch, but you
> > > > seemed busy, so I jumped the gun a little bit.  Let me know how you
> > > > want to do this patch if this approach is wrong.
> > > 
> > > Oh, right, totally forgot about that. yeah I think the blub you have is
> > > adequate. 
> > 
> > I realized I didn't put your sign-off even though I said the patch is from
> > you.  Should I repost with that?  I don't know who is going to take what
> > patches from this series.
> 
> I asked jolsa to pick the lot up since its mostly userspace, if he
> remembers he can put it in.

Yup he told me the samething on irc.  Thanks!!

Cheers,
Don

