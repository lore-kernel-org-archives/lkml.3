Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab3HZMMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:12:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35515 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3HZMML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:12:11 -0400
Date: Mon, 26 Aug 2013 14:12:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [patch, resend] perf: export struct perf_branch_entry to
 userspace
Message-ID: <20130826121202.GM31370@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1307081520520.10386@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1308231544420.1889@vincent-weaver-1.um.maine.edu>
 <CAMsRxf+FU4UhVvgVCww5CuNwfqOk915_-TKK4fC7daFoweMnQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxf+FU4UhVvgVCww5CuNwfqOk915_-TKK4fC7daFoweMnQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 11:31:11AM +0200, Stephane Eranian wrote:
> On Fri, Aug 23, 2013 at 9:51 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
> >
> > On Mon, 8 Jul 2013, Vince Weaver wrote:
> >
> > If PERF_SAMPLE_BRANCH_STACK is enabled then samples are returned
> > with the format { u64 from, to, flags } but the flags layout
> > is not specified.
> >
> > This field has the type struct perf_branch_entry; move this
> > definition into include/uapi/linux/perf_event.h so users can
> > access these fields.
> >
> > This is similar to the existing inclusion of perf_mem_data_src in
> > the include/uapi/linux/perf_event.h file.
> >
> > Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> >
> This makes sense.
> Acked-by: Stephane Eranian <eranian@google.com>

Thanks!
