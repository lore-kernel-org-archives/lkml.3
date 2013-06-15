Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3FOCVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 22:21:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:55985 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab3FOCVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 22:21:24 -0400
Message-ID: <1371262867.21896.27.camel@pasglop>
Subject: Re: Regression in RCU subsystem in latest mainline kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rojhalat Ibrahim <imr@rtschenk.de>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Sat, 15 Jun 2013 12:21:07 +1000
In-Reply-To: <1371262654.9844.340.camel@gandalf.local.home>
References: <1626500.7WAVXjfS9F@pcimr>
	 <20130614122800.GL5146@linux.vnet.ibm.com> <1645938.As0LR1yeVd@pcimr>
	 <1371243967.9844.338.camel@gandalf.local.home>
	 <1371261741.21896.20.camel@pasglop>
	 <1371262654.9844.340.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 22:17 -0400, Steven Rostedt wrote:
> On Sat, 2013-06-15 at 12:02 +1000, Benjamin Herrenschmidt wrote:
> > On Fri, 2013-06-14 at 17:06 -0400, Steven Rostedt wrote:
> > > I was pretty much able to reproduce this on my PA Semi PPC box. Funny
> > > thing is, when I type on the console, it makes progress. Anyway, it
> > > seems that powerpc has an issue with irq_work(). I'll try to get some
> > > time either tonight or next week to figure it out.
> > 
> > Does this help ?
> 
> It did for me. Rojhalat, did this fix your issue too?

Ok, adding that to what I'm about to send to Linus.

Cheers,
Ben.


