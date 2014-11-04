Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaKDPaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:30:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:37945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaKDPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:30:18 -0500
Date: Tue, 4 Nov 2014 16:30:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] perf: Use monotonic clock as a source for
 timestamps
Message-ID: <20141104153009.GJ10501@worktop.programming.kicks-ass.net>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <1415060918-19954-2-git-send-email-pawel.moll@arm.com>
 <20141104072308.GE10501@worktop.programming.kicks-ass.net>
 <1415114727.24819.8.camel@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415114727.24819.8.camel@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 03:25:27PM +0000, Pawel Moll wrote:
> Very good idea, should have came up with it myself :-)
> 
> Does __setup("perf_use_local_clock") sound reasonable?

Would not the 'module' already prefix a perf.? I never quite know how
all that works out. But sure, that works.

> Then we have to
> decide whether to hide the sysctl "perf_sample_time_clk_id" (my
> preferred option, will see how difficult it is) or just provide an
> invalid clock_id (eg. -1) in it.

invalid clock id is fine with me, although I suppose the clock people
might have an oh-pinion ;-)
