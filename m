Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaFCLzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:55:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbaFCLzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:55:37 -0400
Date: Tue, 3 Jun 2014 13:55:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.w.shin@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 2/4] perf tools: allow user to specify hardware
 breakpoint bp_len
Message-ID: <20140603115503.GA2864@krava.brq.redhat.com>
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <1401377213-24551-3-git-send-email-fweisbec@gmail.com>
 <20140530133906.GC7427@krava.brq.redhat.com>
 <87mwduepux.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwduepux.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 10:36:22AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Fri, 30 May 2014 15:39:06 +0200, Jiri Olsa wrote:
> > On Thu, May 29, 2014 at 05:26:51PM +0200, Frederic Weisbecker wrote:
> >> From: Jacob Shin <jacob.w.shin@gmail.com>
> >> 
> >> Currently bp_len is given a default value of 4. Allow user to override it:
> >> 
> >>   $ perf stat -e mem:0x1000/8
> >>                             ^
> >>                             bp_len
> >> 
> >> If no value is given, it will default to 4 as it did before.
> >
> > Namhyung,
> > both perf tols patches from this patchset mess up with hists
> > tests..  I havent found any connection yet.. any idea? ;-)
> 
> So you already found the problem in the hpp->elide change and that's the
> reason of the failure, right? :)

I haven't got a chance to test it yet.. but it looks like
thats the case.. I'll retest soon ;-)

jirka
