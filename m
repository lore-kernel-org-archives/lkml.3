Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaEHNUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:20:23 -0400
Received: from mail.efficios.com ([78.47.125.74]:45668 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaEHNUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:20:21 -0400
Date: Thu, 8 May 2014 13:20:19 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>
Message-ID: <1188725331.13100.1399555219466.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140508091529.08b68cf4@gandalf.local.home>
References: <1399549669-25465-1-git-send-email-mathieu.desnoyers@efficios.com> <20140508090520.2b225a94@gandalf.local.home> <55466295.13096.1399554505453.JavaMail.zimbra@efficios.com> <20140508091529.08b68cf4@gandalf.local.home>
Subject: Re: [PATCH] Fix: tracepoint: use after rcu free
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracepoint: use after rcu free
Thread-Index: mRPhXtslKewzMi3xkvTrWaWgyQO1GA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Sasha Levin" <sasha.levin@oracle.com>, "Oleg Nesterov" <oleg@redhat.com>, "Dave
> Jones" <davej@redhat.com>
> Sent: Thursday, May 8, 2014 9:15:29 AM
> Subject: Re: [PATCH] Fix: tracepoint: use after rcu free
> 
> On Thu, 8 May 2014 13:08:25 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > > 
> > > We can also include a (even though it's redundant)
> > > 
> > >  Fixes: de7b2973903c "tracepoint: Use struct pointer instead of name hash
> > >  for
> > >  reg/unreg tracepoints"
> > 
> > Thanks for the pointers, I'll keep those in mind for my next patches.
> 
> Oh, one more thing I keep forgetting to mention to you. Your subject
> lines :-)
> 
> I converted it to be:
> 
>  tracepoint: Fix use of tracepoint funcs after rcu free
> 
> only the subsystem tag should be used. Not a "Fix" tag. But the "Fix"
> may be used in the subject itself. Also, I've been told that Linus
> prefers to have the subject written more like a sentence and the first
> character capitalized.

OK, I'm taking notes for next time.

Thanks!

Mathieu

> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
