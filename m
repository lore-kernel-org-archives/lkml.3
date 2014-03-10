Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaCJSOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:14:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:2294 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751649AbaCJSOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:14:52 -0400
Date: Mon, 10 Mar 2014 14:14:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH RT 2/5] a few open coded completions
Message-ID: <20140310141449.6b99c7eb@gandalf.local.home>
In-Reply-To: <1394473962.23624.3.camel@deadeye.wl.decadent.org.uk>
References: <20131211003732.351606520@goodmis.org>
	<20131211003801.836995968@goodmis.org>
	<20131211144946.27d82a78@gandalf.local.home>
	<1394324841.2861.56.camel@deadeye.wl.decadent.org.uk>
	<20140310102928.7b2a2cfa@gandalf.local.home>
	<1394473962.23624.3.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 17:52:42 +0000
Ben Hutchings <ben@decadent.org.uk> wrote:

> On Mon, 2014-03-10 at 10:29 -0400, Steven Rostedt wrote:
> > On Sun, 09 Mar 2014 00:27:21 +0000
> > Ben Hutchings <ben@decadent.org.uk> wrote:
> > 
> > > On Wed, 2013-12-11 at 14:49 -0500, Steven Rostedt wrote:
> > > > Here's the new patch:
> > > 
> > > Doesn't add #includes and doesn't change any types, so of course it
> > > doesn't compile.  WTF?
> > > 
> > 
> > Hi Ben,
> > 
> > This is an old thread. Which kernel did you apply it to. Before I send
> > any patch set out, I run a small test (heavy stress test, and also
> > compile several different configs). This patch was against 3.10-rt, and
> > may have already had the includes needed. I know the original patch
> > compiled, but I may not have tested the second patch.
> > 
> > Do you need this patch? Or did I miss something for 3.2-rt?
> 
> You applied it to 3.2-rt:
> 
> commit 916c8d2de3c4759f57426fa3cfee63b491e88939
> Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Date:   Mon Oct 28 11:50:06 2013 +0100
> 
>     swait: Add a few more users
> 
> and 3.4-rt, 3.8-rt, 3.10-rt.  So far as I can see, it is broken on all
> of those branches, though I only actually tried building 3.2-rt.
> 

Can you send me your config. I may just not be hitting it. I've booted
and ran all these kernels I've posted.

I don't run a make allmodconfig as I do on my upstream work. Maybe I'll
have to add that to the mix.

-- Steve
