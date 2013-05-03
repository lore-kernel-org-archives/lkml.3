Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763345Ab3ECS6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 14:58:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48804
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763256Ab3ECS6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 14:58:30 -0400
Date: Fri, 3 May 2013 20:56:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf tools: Add '.' as part of the event 'name' token
Message-ID: <20130503185637.GC30733@dyad.programming.kicks-ass.net>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
 <1359230650-10415-2-git-send-email-jolsa@redhat.com>
 <CABPqkBSH=67hG8VRwHPU3byEancpVqsyetHkSjb4nOScPvcnFA@mail.gmail.com>
 <CABPqkBTPHKf+XTmeyA8PrWReG8Ak6ow9gSwfh4ozK+gvJMze1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTPHKf+XTmeyA8PrWReG8Ak6ow9gSwfh4ozK+gvJMze1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I meant to add that I think it would be more productive if we (you and I) were
> to work on the library to extend it with external text-based event tables that
> could be used by perf either directly or thru the libpfm4 interface.

That would be very useful indeed.. I think we talked about this before. Also
wasn't there some vendor support for this idea as well?

I think we want a format that is relatively simple to parse and human readable
(which excludes XML on both counts ;-).

The main objection of using libpfm4 has always been that its primarily
something else.  It also does the event listing thing, but that's only a small
part of it.

But if we can split out that part and use it in both projects that would be
best I think.
