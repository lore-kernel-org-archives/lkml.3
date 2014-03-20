Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaCTDPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:15:42 -0400
Received: from mail.efficios.com ([78.47.125.74]:58759 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaCTDPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:15:40 -0400
Date: Thu, 20 Mar 2014 03:15:43 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <686288039.7231.1395285343508.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140319230132.5dc57068@gandalf.local.home>
References: <1395268262-31224-1-git-send-email-mathieu.desnoyers@efficios.com> <1395268262-31224-3-git-send-email-mathieu.desnoyers@efficios.com> <20140319230132.5dc57068@gandalf.local.home>
Subject: Re: [RFC PATCH v6 2/3] Tracepoint API doc update: data argument
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF28 (Linux)/8.0.5_GA_5839)
Thread-Topic: Tracepoint API doc update: data argument
Thread-Index: pmcu66puh676fDyoTZ/hYHugKdfcEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>,
> "Andrew Morton" <akpm@linux-foundation.org>
> Sent: Wednesday, March 19, 2014 11:01:32 PM
> Subject: Re: [RFC PATCH v6 2/3] Tracepoint API doc update: data argument
> 
> On Wed, 19 Mar 2014 18:31:01 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Describe the @data argument (probe private data).
> 
> As you probably noticed, I added your previous patch to my tree.
> You don't need to keep this with your patches.

OK, thanks!

Mathieu

> 
> -- Steve
> 
> > 
> > Fixes: 38516ab59fbc "tracing: Let tracepoints have data passed to
> > tracepoint callbacks"
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Ingo Molnar <mingo@kernel.org>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  kernel/tracepoint.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index f27e5f0..2e4bfcb 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -370,6 +370,7 @@ tracepoint_add_probe(const char *name, void *probe,
> > void *data)
> >   * tracepoint_probe_register -  Connect a probe to a tracepoint
> >   * @name: tracepoint name
> >   * @probe: probe handler
> > + * @data: probe private data
> >   *
> >   * Returns 0 if ok, error value on error.
> >   * The probe address must at least be aligned on the architecture pointer
> >   size.
> > @@ -412,6 +413,7 @@ tracepoint_remove_probe(const char *name, void *probe,
> > void *data)
> >   * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
> >   * @name: tracepoint name
> >   * @probe: probe function pointer
> > + * @data: probe private data
> >   *
> >   * We do not need to call a synchronize_sched to make sure the probes have
> >   * finished running before doing a module unload, because the module
> >   unload
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
