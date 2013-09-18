Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3IRLeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:34:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40637 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab3IRLeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:34:22 -0400
Date: Wed, 18 Sep 2013 13:34:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130918113410.GJ9326@twins.programming.kicks-ass.net>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
 <20130913105637.GM31370@twins.programming.kicks-ass.net>
 <20130913141638.GA6799@redhat.com>
 <20130916093719.GR21832@twins.programming.kicks-ass.net>
 <20130916164421.GA17568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916164421.GA17568@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:44:21PM -0400, Dave Jones wrote:
> 
> may be some other option.. Try http://www.codemonkey.org.uk/junk/haswell-config
> 
>  > What kind of hardware are you running this on?
> 
> model name	: Intel(R) Core(TM) i5-4670T CPU @ 2.30GHz

Humpf,.. of course I don't have a hsw system :/

I'll try raising the -C count to 4*nr_cpus for the next few runs.

OK, seems I need to edit trinity for that, someone thought 64 was a big
number.
