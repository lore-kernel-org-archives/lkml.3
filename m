Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaDNXqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:46:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61011 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaDNXqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:46:38 -0400
Date: Tue, 15 Apr 2014 01:46:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 0/3] tracing: syscall_*regfunc() fixes
Message-ID: <20140414234633.GG1877@localhost.localdomain>
References: <1397059882-23063-3-git-send-email-fweisbec@gmail.com>
 <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
 <20140409124249.4081e665@gandalf.local.home>
 <20140409170505.GA27638@redhat.com>
 <20140409170542.GB27638@redhat.com>
 <20140410090643.46ca2226@gandalf.local.home>
 <20140410133435.GB12228@redhat.com>
 <20140411112259.79f0a0ba@gandalf.local.home>
 <20140411155845.GA30199@redhat.com>
 <20140413185828.GA20668@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413185828.GA20668@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 08:58:28PM +0200, Oleg Nesterov wrote:
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
> Frederic! I am sorry, I decided to steal your patch to simplify the
> merging and avoid too many changes in the trivial syscall_*regfunc's.
> In case you do not object, could you add your sob into 2/3 ?

Sure, feel free to add it!

Thanks!

> Otherwise
> I can wait for your patch, then send v3 on top of it.
> 
> 
> 
> Hmm. This is off-topic, but CLONE_KERNEL should die, and kernel_init()
> should be spawned without CLONE_SIGHAND. I'll send another patch.
> 
> Oleg.
> 
