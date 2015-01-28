Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764363AbbA2DlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:41:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:51060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbbA2BlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:20 -0500
Date: Wed, 28 Jan 2015 16:42:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 2/4] sched: Use traced preempt count operations to
 toggle PREEMPT_ACTIVE
Message-ID: <20150128154230.GH23038@twins.programming.kicks-ass.net>
References: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
 <1422404652-29067-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422404652-29067-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 01:24:10AM +0100, Frederic Weisbecker wrote:
> d1f74e20b5b064a130cd0743a256c2d3cfe84010 turned PREEMPT_ACTIVE modifiers
> to use raw untraced preempt count operations. Meanwhile this prevents
> from debugging and tracing preemption disabled if we pull that
> responsibility to schedule() callers (see following patches).
> 
Why do you care anyhow? The trace format has the preempt count in, so
any change is obvious.
