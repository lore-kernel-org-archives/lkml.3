Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaGUMJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:09:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:29600 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754324AbaGUMJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:09:14 -0400
Date: Mon, 21 Jul 2014 08:09:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [for-next][PATCH 20/32] sh: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140721080900.54feea34@gandalf.local.home>
In-Reply-To: <20140721110529.GA32428@console-pimps.org>
References: <20140719131524.009152325@goodmis.org>
	<20140719131612.883904957@goodmis.org>
	<20140721110529.GA32428@console-pimps.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014 12:05:29 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> On Sat, 19 Jul, at 09:15:44AM, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Nothing sets function_trace_stop to disable function tracing anymore.
> > Remove the check for it in the arch code.
> > 
> > [ Please test this on your arch ]
> > 
> > Cc: Matt Fleming <matt@console-pimps.org>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  arch/sh/Kconfig      |  1 -
> >  arch/sh/lib/mcount.S | 24 ++----------------------
> >  2 files changed, 2 insertions(+), 23 deletions(-)
> 
> I no longer have hardware to test this on, but it looks pretty straight
> forward.
> 

Thanks.

I've already pushed this to my next repo, so it's going to keep the
"Please test this on your arch" ;-)

Anyway, the arch has been orphaned, thus it's not really that important.

-- Steve
