Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3IPKoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:44:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47334 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3IPKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:44:01 -0400
Date: Mon, 16 Sep 2013 12:43:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130916104349.GC29018@twins.programming.kicks-ass.net>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
 <20130913105637.GM31370@twins.programming.kicks-ass.net>
 <20130913141638.GA6799@redhat.com>
 <20130916093719.GR21832@twins.programming.kicks-ass.net>
 <20130916102535.GA1071@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916102535.GA1071@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:25:35PM +0200, Ingo Molnar wrote:
> Also, Dave, do you run a single copy of Trinity, or multiple ones? Any 
> special options for Peter to reproduce your crashes?

Trinity seems to spawn a process for each cpu available. So I get to run
24 copies -- I presume they're all seeded differently.
