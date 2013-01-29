Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3A2U6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:58:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab3A2U6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:58:53 -0500
Date: Tue, 29 Jan 2013 17:58:36 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v6 2/2] perf stat: add interval printing
Message-ID: <20130129205836.GB6896@infradead.org>
References: <1358860732-4435-1-git-send-email-eranian@google.com>
 <1358860732-4435-3-git-send-email-eranian@google.com>
 <20130125025247.GA16249@infradead.org>
 <CABPqkBT-JuR=3q4X2o7Et9idd3T5Ut_GSnhpQKbqfr5SC4eDWA@mail.gmail.com>
 <20130128175938.GA15351@infradead.org>
 <CABPqkBS9yPGb3DOZv9qTULZrP+-8Zrbri99ZGBt7KopTfPWEfQ@mail.gmail.com>
 <20130128192151.GC15351@infradead.org>
 <CABPqkBQRZaErbJeJjcCZYzJOFe0WuAN3s5KYVojgTT8N3STKXg@mail.gmail.com>
 <20130129014125.GD15351@infradead.org>
 <CABPqkBRJD1DEBGO8xniQwzVFg8_R2SbbebQ1JefZ_f39oms9yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRJD1DEBGO8xniQwzVFg8_R2SbbebQ1JefZ_f39oms9yg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 29, 2013 at 12:48:51PM +0100, Stephane Eranian escreveu:
> Arnaldo,
> 
> V7 posted. It's a rebase done against your perf/core, was no big deal.
> Let me know if it works for you now.

Thanks, it is now merged in my perf/core branch,

- Arnaldo
 
> 
> On Tue, Jan 29, 2013 at 2:41 AM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Em Mon, Jan 28, 2013 at 11:45:56PM +0100, Stephane Eranian escreveu:
> >> On Mon, Jan 28, 2013 at 8:21 PM, Arnaldo Carvalho de Melo
> >> <acme@redhat.com> wrote:
> >> > Em Mon, Jan 28, 2013 at 07:26:17PM +0100, Stephane Eranian escreveu:
> >> >> On Mon, Jan 28, 2013 at 6:59 PM, Arnaldo Carvalho de Melo
> >> >> <acme@redhat.com> wrote:
> >> >> > Em Fri, Jan 25, 2013 at 04:21:11PM +0100, Stephane Eranian escreveu:
> >> >> >> My patches are always relative to:
> >> >> >> git://git.kernel.org/pub/scm/linux/kernel/git/tip.tip.git
> >
> >> >> >> Do you still need to rebase against your tree?
> >
> >> >> > Well, userspace code normally is developed on my tree and eventually
> >> >> > goes to the one you mentioned. If you make sure that now, that both are
> >> >> > synched after some weeks, then probably it'll work with my tree.
> >
> >> >> How's the kernel proper side of your tree sync'd with tip.git? I cannot have
> >> >> the kernel patches for one tree and the perf patches for another. That's a
> >> >> lot of overhead especially when it comes to testing.
> >
> >> > Normally regularly, right now it seems all is synched.
> >
> >> Ok, will resubmit the series against your tree then.
> >
> > Also everytime Ingo merges I rebase my tree against tip/perf/core, if
> > you ever need something that is in some other branch that everybody
> > agrees will go upstream, like tip/perf/urgent or Linus's, just let me
> > know and I'll coordinate with Ingo and merge it into acme/perf/core.
> >
> > Talking about that I need to merge tip/perf/urgent, Jiri needs that
> > precise attribute revert...
> >
> > - Arnaldo
