Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbaDITuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:50:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54039 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440AbaDITuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:50:01 -0400
Date: Wed, 9 Apr 2014 21:49:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
 for_each_thread()
Message-ID: <20140409194957.GD26782@laptop.programming.kicks-ass.net>
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
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 09:46:03PM +0200, Oleg Nesterov wrote:
> On 04/09, Peter Zijlstra wrote:
> >
> > Cute,.. and all that lives in sched.h and I wasn't even Cc'ed :-(
> 
> Sorry ;) I didn't think you can be interested. I'll cc you in future,
> this still needs more work.

In general anything locking and/or task related, and this is both, is
'interesting'.

Anyway, I'll look over the stuff tomorrow.
