Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3FQNv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:51:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3FQNv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:51:56 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=w1cNLofYa50A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=yqaEuN8awxIA:10 a=jftd6GDzklWGfV9mnzAA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371477109.18733.7.camel@gandalf.local.home>
Subject: Re: Regression in RCU subsystem in latest mainline kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: Rojhalat Ibrahim <imr@rtschenk.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 17 Jun 2013 09:51:49 -0400
In-Reply-To: <1558776.vQIgbXvFW8@pcimr>
References: <1626500.7WAVXjfS9F@pcimr> <1371261741.21896.20.camel@pasglop>
	 <1371262654.9844.340.camel@gandalf.local.home> <1558776.vQIgbXvFW8@pcimr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 15:21 +0200, Rojhalat Ibrahim wrote:
> On Friday 14 June 2013 22:17:34 Steven Rostedt wrote:
> > On Sat, 2013-06-15 at 12:02 +1000, Benjamin Herrenschmidt wrote:
> > > On Fri, 2013-06-14 at 17:06 -0400, Steven Rostedt wrote:
> > > > I was pretty much able to reproduce this on my PA Semi PPC box. Funny
> > > > thing is, when I type on the console, it makes progress. Anyway, it
> > > > seems that powerpc has an issue with irq_work(). I'll try to get some
> > > > time either tonight or next week to figure it out.
> > > 
> > > Does this help ?
> > 
> > It did for me. Rojhalat, did this fix your issue too?
> > 
> 
> FWIW, since the fix is already applied, but it fixes my problem too.
> 

Thanks for the update. Yeah, Ben was about to send a queue to Linus, and
as this proved to fix it for me, he felt that it needed to go in that
queue instead of waiting for an update.

But I do appreciate the update as I wasn't 100% that this would fix the
problem for you too.

-- Steve


