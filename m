Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3DMCkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 22:40:20 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42090 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3DMCkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 22:40:19 -0400
Subject: Re: [PATCH 5/6] tools lib traceevent: Add page_size field to pevent
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1365819257.9609.109.camel@gandalf.local.home>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
	 <1365681898-19897-5-git-send-email-namhyung@kernel.org>
	 <1365691175.9609.33.camel@gandalf.local.home>
	 <1365691255.9609.34.camel@gandalf.local.home>
	 <1365815846.1769.11.camel@leonhard>
	 <1365816410.9609.106.camel@gandalf.local.home>
	 <1365818888.1769.49.camel@leonhard>
	 <1365819257.9609.109.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Apr 2013 11:40:10 +0900
Message-ID: <1365820810.1769.55.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-04-12 (금), 22:14 -0400, Steven Rostedt:
> On Sat, 2013-04-13 at 11:08 +0900, Namhyung Kim wrote:
> > 2013-04-12 (금), 21:26 -0400, Steven Rostedt:
> 
> > I think it only affects trace-cmd as it's the only user that accesses
> > raw ring-buffer contents for now.  I found it during writing code also
> > accesses the ring buffer (with kbuffer code) - perf ftrace. :)
> > 
> > But the code is in a very early stage and needs to handle so many things
> > before posting to the list.  So I just wanted to post a part of the
> > preparation first.
> 
> I understand. But people tend to not like things in upstream that has no
> user. If Arnaldo wants to include it, that's his decision. I'm just
> worried that if it takes a while before your other work gets mainline,
> people might start sending patches to remove that code and your stuff
> will suddenly break.

Fair enough.

Arnaldo, what do you think?  Do you want me to resend it with new
description now?

Thanks,
Namhyung


