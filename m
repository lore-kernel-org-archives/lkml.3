Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbaDITqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934416AbaDITqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:46:20 -0400
Date: Wed, 9 Apr 2014 21:46:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
	for_each_thread()
Message-ID: <20140409194603.GB5854@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-2-git-send-email-fweisbec@gmail.com> <20140409171607.GA13498@dyad.arnhem.chello.nl> <20140409173233.GA28615@redhat.com> <20140409183017.GF10526@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409183017.GF10526@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Peter Zijlstra wrote:
>
> Cute,.. and all that lives in sched.h and I wasn't even Cc'ed :-(

Sorry ;) I didn't think you can be interested. I'll cc you in future,
this still needs more work.

Oleg.

