Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3JGLcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:32:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33258 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab3JGLcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:32:33 -0400
Date: Mon, 7 Oct 2013 13:32:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131007113214.GF3081@twins.programming.kicks-ass.net>
References: <CABPqkBSRV651SynNHpAo7-B+8aX2hsMXKJNeTkimBoWo91TvFQ@mail.gmail.com>
 <20130930165420.GI3081@twins.programming.kicks-ass.net>
 <CABPqkBS_zDkgX4NioducZ+H9VEt1jb7gQDbZ_zB6ui5Tf=UR5A@mail.gmail.com>
 <20131002112316.GP3081@twins.programming.kicks-ass.net>
 <20131002115826.GM26785@twins.programming.kicks-ass.net>
 <20131002123953.GB27811@gmail.com>
 <20131002124610.GD28601@twins.programming.kicks-ass.net>
 <CABPqkBQyCfz5d+SQxDwPD5m52ofE6y5HKur+s-F0s=hN00cxkw@mail.gmail.com>
 <20131002130143.GF28601@twins.programming.kicks-ass.net>
 <CABPqkBQs1bjOoPVZKWc09+12Bs1DaLk9z+J4c6UK1C2mZfSGJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQs1bjOoPVZKWc09+12Bs1DaLk9z+J4c6UK1C2mZfSGJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 01:16:35PM +0200, Stephane Eranian wrote:
> I am going to try this out today. I think if it works well, we could
> also simplify the
> MMAP2 record and just pass this unique id for all cases.MMAP2 is only in rcX
> release so far. Is that still possible?

Yeah I think so.
