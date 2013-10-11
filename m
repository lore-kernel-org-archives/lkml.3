Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab3JKN3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:29:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:47129 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab3JKN3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:29:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1080,1371106800"; 
   d="scan'208";a="373460650"
Message-ID: <1381498183.19281.12.camel@empanada>
Subject: Re: [PATCH v10 11/12] tracing: fix tracing_snapshot kerneldoc
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Date: Fri, 11 Oct 2013 08:29:43 -0500
In-Reply-To: <5257F408.9040503@hitachi.com>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
	 <af1e1b69b339a85e11f580af9c3ba6dfa28cb20f.1381445299.git.tom.zanussi@linux.intel.com>
	 <5257F408.9040503@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 21:50 +0900, Masami Hiramatsu wrote:
> (2013/10/11 9:48), Tom Zanussi wrote:
> > The names of the functions are tracing_snapshot_*, not
> > trace_snapshot_* - fix up the kerneldoc to avoid confusion.
> > 
> > Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> 
> It seems that this is not related this series.
> Please send it as a trivial fix patch :)
> 

Yeah, I keep adding patches as I test things, and 4 of the patches in
this patchset now fit that description..

Tom

> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> > ---
> >  kernel/trace/trace.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 5aa8f80..81d95bf 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -514,7 +514,7 @@ EXPORT_SYMBOL_GPL(__trace_bputs);
> >  
> >  #ifdef CONFIG_TRACER_SNAPSHOT
> >  /**
> > - * trace_snapshot - take a snapshot of the current buffer.
> > + * tracing_snapshot - take a snapshot of the current buffer.
> >   *
> >   * This causes a swap between the snapshot buffer and the current live
> >   * tracing buffer. You can use this to take snapshots of the live
> > @@ -617,9 +617,9 @@ int tracing_alloc_snapshot(void)
> >  EXPORT_SYMBOL_GPL(tracing_alloc_snapshot);
> >  
> >  /**
> > - * trace_snapshot_alloc - allocate and take a snapshot of the current buffer.
> > + * tracing_snapshot_alloc - allocate and take a snapshot of the current buffer.
> >   *
> > - * This is similar to trace_snapshot(), but it will allocate the
> > + * This is similar to tracing_snapshot(), but it will allocate the
> >   * snapshot buffer if it isn't already allocated. Use this only
> >   * where it is safe to sleep, as the allocation may sleep.
> >   *
> > 
> 
> 


