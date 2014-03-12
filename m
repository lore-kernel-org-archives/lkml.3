Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaCLAwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:52:44 -0400
Received: from mail.efficios.com ([78.47.125.74]:47194 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbaCLAwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:52:30 -0400
Date: Wed, 12 Mar 2014 00:52:33 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <1594586075.484.1394585553228.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140311193450.60bbf8b0@gandalf.local.home>
References: <1394499898-1537-1-git-send-email-mathieu.desnoyers@efficios.com> <20140311193450.60bbf8b0@gandalf.local.home>
Subject: Re: [PATCH 1/2] Tracepoint API doc update: data argument
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: Tracepoint API doc update: data argument
Thread-Index: IMju1Jw7c0wuODwSbU0t5TQNfMCRog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>,
> "Andrew Morton" <akpm@linux-foundation.org>
> Sent: Tuesday, March 11, 2014 7:34:50 PM
> Subject: Re: [PATCH 1/2] Tracepoint API doc update: data argument
> 
> On Mon, 10 Mar 2014 21:04:57 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Describe the @data argument (probe private data).
> > 
> > Fixes: 38516ab59fbc "tracing: Let tracepoints have data passed to
> > tracepoint callbacks"
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Ingo Molnar <mingo@kernel.org>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> 
> No signed-off-by.

Hi Steven,

I'm curious to understand the reason of this "no signed-off-by" on a trivial
patch that fixes the missing DocBook comments for one of your previous
commits that has been upstream for a few years. What am I missing ?
Perhaps you meant this reply for my other documentation update patch (2/2) ?

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
