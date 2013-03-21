Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854Ab3CUQAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:00:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58444 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994Ab3CUQAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:00:21 -0400
Date: Thu, 21 Mar 2013 17:00:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130321160015.GA10992@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
	josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
	geoff@infradead.org, tglx@linutronix.de,
	Arjan van de Ven <arjan@linux.intel.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
 <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <1363825631.6345.45.camel@gandalf.local.home>
 <20130321022259.GM3637@linux.vnet.ibm.com>
 <20130321101650.GA11214@pd.tnic>
 <20130321151811.GR3637@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130321151811.GR3637@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 08:18:11AM -0700, Paul E. McKenney wrote:
> Actually, this is a generic transformation. Given an English verb,
> you almost always add "ing" to create a noun. Since "round-robin" is
> used as a verb,

... which sounds, in this case, weird IMHO. :-)

> as in "The scheduler will round-robin between the two SCHED_RR
> tasks",

I think the "correct" way to say it is "The scheduler will select tasks
in a round-robin fashion..." But while it is correct (for some accepted
definition of correct), this is slow, has too many words and we don't
want that - we want fast! We want a lot less instructions in the pipe!
This way, we burn a lot less energy when talking. :-)

> "round-robining" may be used as a noun denoting the action
> corresponding to the verb "round-robin". There is no doubt an
> argument as to whether this should be spelled "round-robining" or
> "round-robinning", but I will leave this to those who care enough to
> argue about it. ;-)

Hey sir, you're preaching to the choir - I'm all for doing all kinds of
weird/funny experiments with language...

> The thing about English is that it is an open-source language, and
> always has been. English is defined by its usage, and the wise
> dictionary-makers try their best to keep up.

... yes, and then there are the English language Nazis who wouldn't
allow that - their rules are stricter than software APIs and breaking
userspace compatibility.

Technical people, OTOH, are much more willing and not afraid to take the
language and mold it in such a form so that it works for them instead of
adhering to ancient rules. Which is cool. That's why I was pointing out
the "round-robining" - nice and cool. And look how much shorter it is:

round-robining = iterate over the items on a list by periodically
switching from one to the next in a circular order.

Now imagine the pressure on I$ the two versions create. And compare. :-)

> (The unwise ones attempt to stop the evolution of the English
> language.) Everything good and everything bad about English stems from
> this property. ;-)

Yeah, I've had to deal with enough of those evolution-stopping idiots
during my days at the university. Well, I've got three words for them:
"Resistance is futile!"

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
