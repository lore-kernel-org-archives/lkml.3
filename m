Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbaDJH47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:56:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34844 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbaDJH45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:56:57 -0400
Date: Thu, 10 Apr 2014 09:56:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
 for_each_thread()
Message-ID: <20140410075653.GA28561@gmail.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
 <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
 <20140409171607.GA13498@dyad.arnhem.chello.nl>
 <20140409173233.GA28615@redhat.com>
 <20140409183017.GF10526@twins.programming.kicks-ass.net>
 <20140409194603.GB5854@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409194603.GB5854@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/09, Peter Zijlstra wrote:
> >
> > Cute,.. and all that lives in sched.h and I wasn't even Cc'ed :-(
> 
> Sorry ;) I didn't think you can be interested. I'll cc you in future,
> this still needs more work.

Please generally Cc: the folks listed in:

  scripts/get_maintainer.pl -f include/linux/sched.h

If maintainers are truly not interested in changes to a file they are 
listed to maintain then they'll get it unlisted in the MAINTAINERS 
patterns.

Thanks,

	Ingo
