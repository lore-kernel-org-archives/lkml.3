Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaEHNPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:15:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:53084 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754286AbaEHNPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:15:31 -0400
Date: Thu, 8 May 2014 09:15:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix: tracepoint: use after rcu free
Message-ID: <20140508091529.08b68cf4@gandalf.local.home>
In-Reply-To: <55466295.13096.1399554505453.JavaMail.zimbra@efficios.com>
References: <1399549669-25465-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140508090520.2b225a94@gandalf.local.home>
	<55466295.13096.1399554505453.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014 13:08:25 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > 
> > We can also include a (even though it's redundant)
> > 
> >  Fixes: de7b2973903c "tracepoint: Use struct pointer instead of name hash for
> >  reg/unreg tracepoints"
> 
> Thanks for the pointers, I'll keep those in mind for my next patches.

Oh, one more thing I keep forgetting to mention to you. Your subject
lines :-)

I converted it to be:

 tracepoint: Fix use of tracepoint funcs after rcu free

only the subsystem tag should be used. Not a "Fix" tag. But the "Fix"
may be used in the subject itself. Also, I've been told that Linus
prefers to have the subject written more like a sentence and the first
character capitalized.

-- Steve
