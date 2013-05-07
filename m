Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab3EGIou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:44:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36082 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776Ab3EGIoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:44:46 -0400
Date: Tue, 7 May 2013 10:43:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't allow unusual PEBS raw flags
Message-ID: <20130507084314.GC9688@dyad.programming.kicks-ass.net>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <1366844694-2770-2-git-send-email-andi@firstfloor.org>
 <20130502073720.GH7521@dyad.programming.kicks-ass.net>
 <CABPqkBQb23aJJXhrnYOOG+RWZgfVfyAFS+ksAKxczVOqjtricQ@mail.gmail.com>
 <20130506185226.GA17723@dyad.programming.kicks-ass.net>
 <CABPqkBREmUfuPBvCvBF+4YNvzfuqgDffVvfUFE5_w6Yx88mBZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBREmUfuPBvCvBF+4YNvzfuqgDffVvfUFE5_w6Yx88mBZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 12:43:04AM +0200, Stephane Eranian wrote:
> But that implies that you'd know that on Intel precise mode uses PEBS
> and that PEBS
> does not take cmask events. That seems to contradict the philosophy of
> perf_events
> where the kernel does the work for you.

This is basically raw event territory (hidden in a nice syntax). This is very
much a you're on your own case.

But it appears there's more behind this than was said; which makes this patch
submission duplicitous and trying to sneak one past the maintainers -- that's
very much not how things are done.

I'm not taking anything like this until the Changelog reflects the true
purpose.
