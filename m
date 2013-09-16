Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab3IPQp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:45:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab3IPQp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:45:58 -0400
Date: Mon, 16 Sep 2013 12:45:26 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130916164526.GB17568@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
 <20130913105637.GM31370@twins.programming.kicks-ass.net>
 <20130913141638.GA6799@redhat.com>
 <20130916093719.GR21832@twins.programming.kicks-ass.net>
 <20130916102535.GA1071@gmail.com>
 <20130916104349.GC29018@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916104349.GC29018@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:43:49PM +0200, Peter Zijlstra wrote:
 > On Mon, Sep 16, 2013 at 12:25:35PM +0200, Ingo Molnar wrote:
 > > Also, Dave, do you run a single copy of Trinity, or multiple ones? Any 
 > > special options for Peter to reproduce your crashes?
 > 
 > Trinity seems to spawn a process for each cpu available. So I get to run
 > 24 copies -- I presume they're all seeded differently.

They are. And I can trip up that bug with just a single instance of trinity.
(I was running more processes than cpu count though, with -C32)

	Dave

