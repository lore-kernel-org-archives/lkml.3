Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3FZOt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:49:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58873 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3FZOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:49:57 -0400
Date: Wed, 26 Jun 2013 14:24:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
Message-ID: <20130626122408.GJ28407@twins.programming.kicks-ass.net>
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 06:41:15PM -0400, Sasha Levin wrote:
> liblockdep is a tiny wrapper built around kernel/lockdep.c. The aim is to
> provide the same functionality the kernel gets from lockdep to userspace.
> 
> The bulk of the code here is the LD_PRELOAD support which provides users
> an easy way to test their code without having to integrate liblockdep into
> said code. Simply doing:
> 
>         lockdep my_app
> 
> Would provide lockdep support to my_app.
> 
> There is also a small test suite to test both mutexes and rwlocks, it's
> based on the tests in lib/locking-selftest.c.
> 
> This entire patch series was reviewed by lockdep maintainers and accepted to
> the tip tree previously. It was pulled out so that the potential merge of
> liblockdep won't delay the rest of the commits in the tip locking tree.
> 
> For some more background about this entire thing, the folks at LWN did
> an awesome overview: http://lwn.net/Articles/536363/
> 

Ingo, I don't think I see anything holding this back; however I remember
reading some email about people not liking stuff like this living in the
tools/ directory or such.

Will you pick this up?
