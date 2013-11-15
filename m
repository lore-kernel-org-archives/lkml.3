Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3KOKur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:50:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49375 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab3KOKuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:50:37 -0500
Date: Fri, 15 Nov 2013 11:50:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
Message-ID: <20131115105027.GB10456@twins.programming.kicks-ass.net>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
 <20131115063457.GB12442@gmail.com>
 <CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
 <20131115103405.GA18264@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115103405.GA18264@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:34:05AM +0100, Ingo Molnar wrote:
> That brings up an interesting question: what is better for users, if 
> we schedule as many as we can and say 'not supported' to the rest 
> (current behavior), or if we fail the whole group?

Obviously fail the whole group :-)
