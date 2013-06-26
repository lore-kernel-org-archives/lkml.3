Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3FZPZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:25:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60795 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3FZPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:24:52 -0400
Date: Wed, 26 Jun 2013 12:36:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/8] perf,x86: drop event->flags and use
 hw.constraint->flags
Message-ID: <20130626103653.GC28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <1371824448-7306-3-git-send-email-eranian@google.com>
 <20130624084510.GK28407@twins.programming.kicks-ass.net>
 <CABPqkBQRchnjhnEC05w-noizoeSRnNio7NDQ6_+vXym_7rkGaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQRchnjhnEC05w-noizoeSRnNio7NDQ6_+vXym_7rkGaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 09:36:39AM +0200, Stephane Eranian wrote:
> On Mon, Jun 24, 2013 at 10:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Jun 21, 2013 at 04:20:42PM +0200, Stephane Eranian wrote:
> >> Now that we use the contraints directly from the event, we
> >> do not need the event->flags field so drop it.
> >>
> >> Signed-off-by: Stephane Eranian <eranian@google.com>
> >
> > Same for this one I suppose; its not really related to the series at
> > hand.
> 
> Correct. I can submit separately if needed.

I applied the first patch; this one failed to apply.. Remind me again if
I fail to remember looking at the rejects once I've collected all other
patches I planned to ship to mingo today.
