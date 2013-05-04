Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab3EDIK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 04:10:59 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60048 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab3EDIKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 04:10:22 -0400
Date: Sat, 4 May 2013 10:10:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf tools: Add '.' as part of the event 'name' token
Message-ID: <20130504081017.GC14614@gmail.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
 <1359230650-10415-2-git-send-email-jolsa@redhat.com>
 <CABPqkBSH=67hG8VRwHPU3byEancpVqsyetHkSjb4nOScPvcnFA@mail.gmail.com>
 <CABPqkBTPHKf+XTmeyA8PrWReG8Ak6ow9gSwfh4ozK+gvJMze1w@mail.gmail.com>
 <20130503185637.GC30733@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503185637.GC30733@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > I meant to add that I think it would be more productive if we (you and I) were
> > to work on the library to extend it with external text-based event tables that
> > could be used by perf either directly or thru the libpfm4 interface.
> 
> That would be very useful indeed.. I think we talked about this before. 
> Also wasn't there some vendor support for this idea as well?
> 
> I think we want a format that is relatively simple to parse and human 
> readable (which excludes XML on both counts ;-).
> 
> The main objection of using libpfm4 has always been that its primarily 
> something else.  It also does the event listing thing, but that's only a 
> small part of it.
> 
> But if we can split out that part and use it in both projects that would 
> be best I think.

If that libpfm reference library moved to tools/lib/ like 
tools/lib/traceevents/ then that would be a nice, useful solution indeed.

Thanks,

	Ingo
