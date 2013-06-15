Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3FOCvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 22:51:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48223 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3FOCvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 22:51:42 -0400
Date: Fri, 14 Jun 2013 19:51:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rojhalat Ibrahim <imr@rtschenk.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Regression in RCU subsystem in latest mainline kernel
Message-ID: <20130615025139.GU5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1626500.7WAVXjfS9F@pcimr>
 <20130614122800.GL5146@linux.vnet.ibm.com>
 <1645938.As0LR1yeVd@pcimr>
 <1371243967.9844.338.camel@gandalf.local.home>
 <1371261741.21896.20.camel@pasglop>
 <1371262654.9844.340.camel@gandalf.local.home>
 <1371262867.21896.27.camel@pasglop>
 <1371263472.9844.341.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371263472.9844.341.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061502-2876-0000-0000-000009DE00E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:31:12PM -0400, Steven Rostedt wrote:
> On Sat, 2013-06-15 at 12:21 +1000, Benjamin Herrenschmidt wrote:
> > On Fri, 2013-06-14 at 22:17 -0400, Steven Rostedt wrote:
> > > On Sat, 2013-06-15 at 12:02 +1000, Benjamin Herrenschmidt wrote:
> > > > On Fri, 2013-06-14 at 17:06 -0400, Steven Rostedt wrote:
> > > > > I was pretty much able to reproduce this on my PA Semi PPC box. Funny
> > > > > thing is, when I type on the console, it makes progress. Anyway, it
> > > > > seems that powerpc has an issue with irq_work(). I'll try to get some
> > > > > time either tonight or next week to figure it out.
> > > > 
> > > > Does this help ?
> > > 
> > > It did for me. Rojhalat, did this fix your issue too?
> > 
> > Ok, adding that to what I'm about to send to Linus.
> 
> Feel free to add: Tested-by: Steven Rostedt <rostedt@goodmis.org>

Thank you both!!!

							Thanx, Paul

