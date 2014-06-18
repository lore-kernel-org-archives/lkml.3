Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967108AbaFROXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:23:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:29389 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S967077AbaFROXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:23:48 -0400
Date: Wed, 18 Jun 2014 10:23:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 0/3] tracing: syscall_*regfunc() fixes
Message-ID: <20140618102343.24365846@gandalf.local.home>
In-Reply-To: <20140413185828.GA20668@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
	<1397059882-23063-3-git-send-email-fweisbec@gmail.com>
	<360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
	<20140409124249.4081e665@gandalf.local.home>
	<20140409170505.GA27638@redhat.com>
	<20140409170542.GB27638@redhat.com>
	<20140410090643.46ca2226@gandalf.local.home>
	<20140410133435.GB12228@redhat.com>
	<20140411112259.79f0a0ba@gandalf.local.home>
	<20140411155845.GA30199@redhat.com>
	<20140413185828.GA20668@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014 20:58:28 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/11, Oleg Nesterov wrote:
> >
> > On 04/11, Steven Rostedt wrote:
> > >
> > > Are you going to send a new series?
> >
> > Yes, will do. I will split 1/2, and I need to update the changelog
> > in 2/2.
> 
> Please see the patches.
> 

I'm pulling these in now and will start tests, wont be till tomorrow
till I can push them.

If you start a new patch series, either make them a new thread or at
least a reply from the 0/x of the previous version. Having a v2 series
starting at the bottom of the 1/x thread will get lost.

-- Steve
