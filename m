Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab3K1DQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:16:20 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42581 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab3K1DQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:16:16 -0500
Date: Wed, 27 Nov 2013 22:16:10 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Message-ID: <20131128031610.GL3556@cmpxchg.org>
References: <20131118154115.GA3556@cmpxchg.org>
 <20131118165110.GE32623@dhcp22.suse.cz>
 <20131122165100.GN3556@cmpxchg.org>
 <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com>
 <20131127163435.GA3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271343250.9222@chino.kir.corp.google.com>
 <20131127231931.GG3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271613340.10617@chino.kir.corp.google.com>
 <20131128022804.GJ3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271839290.5120@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311271839290.5120@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 06:52:10PM -0800, David Rientjes wrote:
> On Wed, 27 Nov 2013, Johannes Weiner wrote:
> 
> > The long-standing, user-visible definition of the current line agrees
> > with me.  You can't just redefine this, period.
> > 
> > I tried to explain to you how insane the motivation for this patch is,
> > but it does not look like you are reading what I write.  But you don't
> > get to change user-visible behavior just like that anyway, much less
> > so without a sane reason, so this was a complete waste of time :-(
> > 
> 
> If you would like to leave this to Andrew's decision, that's fine.  
> Michal has already agreed with my patch and has acked it in -mm.
> 
> If userspace is going to handle oom conditions, which is possible today 
> and will be extended in the future, then it should only wakeup as a last 
> resort when there is no possibility of future memory freeing.

I'll ack a patch that accomplishes that.
