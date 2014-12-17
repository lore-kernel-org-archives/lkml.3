Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109AbaLQPfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:35:32 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:35:31 -0500
Date: Wed, 17 Dec 2014 16:35:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] perf: Avoid horrible stack usage
Message-ID: <20141217153508.GC30905@twins.programming.kicks-ass.net>
References: <20141216115041.GW3337@twins.programming.kicks-ass.net>
 <20141217143105.GG18257@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217143105.GG18257@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 03:31:05PM +0100, Jiri Olsa wrote:
> looks like we could also sanitize the perf_ftrace_function_call
> in the same way.. like below (untested)
> 
> hum, I just noticed it actually has pt_regs arg ;-)

Bu if it has pt_regs should we not use that instead of filling one out
again?
