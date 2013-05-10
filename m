Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab3EJKlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:41:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3EJKlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:41:46 -0400
Date: Fri, 10 May 2013 12:40:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched: use this_rq() helper
Message-ID: <20130510104015.GD31235@dyad.programming.kicks-ass.net>
References: <1368116643-87971-1-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368116643-87971-1-git-send-email-nzimmer@sgi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:24:03AM -0500, Nathan Zimmer wrote:
> It is a few instructions more efficent to and slightly more readable to use
> this_rq()-> instead of cpu_rq(smp_processor_id()->

If you've taken the trouble of actually measuring this, including the
measurement results is appreciated.

But yes, it also makes the code slightly smaller.

Thanks!

Acked-by: Peter Zijlstra <peterz@infradead.org> 

