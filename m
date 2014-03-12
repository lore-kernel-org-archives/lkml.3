Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbaCLBOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:14:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:50158 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756103AbaCLBOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:14:05 -0400
Date: Tue, 11 Mar 2014 21:14:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Tracepoint API doc update: data argument
Message-ID: <20140311211402.6245c6d0@gandalf.local.home>
In-Reply-To: <1594586075.484.1394585553228.JavaMail.zimbra@efficios.com>
References: <1394499898-1537-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140311193450.60bbf8b0@gandalf.local.home>
	<1594586075.484.1394585553228.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 00:52:33 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Steven Rostedt" <rostedt@goodmis.org>
> > To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>,
> > "Andrew Morton" <akpm@linux-foundation.org>
> > Sent: Tuesday, March 11, 2014 7:34:50 PM
> > Subject: Re: [PATCH 1/2] Tracepoint API doc update: data argument
> > 
> > On Mon, 10 Mar 2014 21:04:57 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > Describe the @data argument (probe private data).
> > > 
> > > Fixes: 38516ab59fbc "tracing: Let tracepoints have data passed to
> > > tracepoint callbacks"
> > > CC: Steven Rostedt <rostedt@goodmis.org>
> > > CC: Ingo Molnar <mingo@kernel.org>
> > > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > > CC: Andrew Morton <akpm@linux-foundation.org>
> > 
> > No signed-off-by.
> 
> Hi Steven,
> 
> I'm curious to understand the reason of this "no signed-off-by" on a trivial
> patch that fixes the missing DocBook comments for one of your previous
> commits that has been upstream for a few years. What am I missing ?
> Perhaps you meant this reply for my other documentation update patch (2/2) ?
> 

I mean, my scripts wont accept a patch that the author never added
their signed-off-by to.

In other words, resubmit, and add your own signed-off-by that happens to
be missing from this patch.

-- Steve
