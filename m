Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbaLJQ2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:28:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbaLJQ2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:28:30 -0500
Date: Wed, 10 Dec 2014 17:12:46 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [BUG] perf mem: perf mem report fails in TUI mode
Message-ID: <20141210161246.GA5203@krava.brq.redhat.com>
References: <CABPqkBTLjQPymwDgNKdOshZimKQ0DGWaqm0gC8uFbwPK7vWrsA@mail.gmail.com>
 <20141210153014.GC6877@krava.brq.redhat.com>
 <CABPqkBThUvnJLcddd8Uik_Ssk-a6wojrB6rVCvg-Stzg2Bk+6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBThUvnJLcddd8Uik_Ssk-a6wojrB6rVCvg-Stzg2Bk+6A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:46:59AM -0500, Stephane Eranian wrote:
> On Wed, Dec 10, 2014 at 10:30 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Tue, Dec 09, 2014 at 11:15:13PM -0500, Stephane Eranian wrote:
> >> Hi,
> >>
> >> I was running a couple of tests with perf mem from tip.git and
> >> found that perf mem -t load rep was failing only in TUI mode.
> >> With --stdio, it works fine. I did a bit of investigation and found
> >> out that the TUI mode is failing because some symbol (kernel)
> >> is showing up with a huge (negative) size. I don't understand
> >> the connection between the TUI vs. tty browser and symbols.
> >>
> >> To reproduce:
> >>     $ perf mem -t load rec my_test_program
> >>     $ perf mem -t load rep
> >>     $ perf mem -t load rep --stdio
> >
> > hi,
> > I couldn't reproduce any failure on the acme's perf/core
> >
> What about tip.git?

works for me

> 
> > since you indicated it's data dependent, could you share
> > your perf.data?
> >
> I can send it to you directly.

ok, I'll check

jirka
