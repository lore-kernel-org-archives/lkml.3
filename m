Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3JYKTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:19:48 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54076 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JYKTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:19:46 -0400
Date: Fri, 25 Oct 2013 12:19:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: perf/ftrace lockup on 3.12-rc6 with trigger code
Message-ID: <20131025101943.GA3481@gmail.com>
References: <alpine.DEB.2.10.1310241324330.4352@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1310241422460.6573@vincent-weaver-1.um.maine.edu>
 <1382695687.12254.4.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382695687.12254.4.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > Urgh, I had turned those on to try to debug something and forgot 
> > to disable.  I feel like I saw this problem before I had those 
> > enabled so I guess I have to start from scratch fuzzing to see 
> > if I can get a more generally reproducible trace.

Btw., even if various config options are enabled, we don't want the 
kernel to lock up. So it might not be _the_ bug you are looking, but 
it certainly looks like _a_ bug.

> Looks like something is incorrectly enabling function tracer 
> within perf. Peter told me that there's some ref count bug that 
> may use data after being freed on exit.
> 
> I tried the program that you attached in you previous email, and 
> was not able to hit the bug. Are you able to hit the bug with that 
> code each time?

A full .config and a SHA1 of the tested tree would definitely be 
nice!

Thanks,

	Ingo
