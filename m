Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaKBHaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:30:35 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:53772 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaKBHad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:30:33 -0500
Message-ID: <1414913427.5380.110.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14.23-rt20
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Sun, 02 Nov 2014 08:30:27 +0100
In-Reply-To: <20141031170326.1491a63f@gandalf.local.home>
References: <20141031170326.1491a63f@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 17:03 -0400, Steven Rostedt wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.14.23-rt20 stable release.
> 
> This is the first 3.14-rt release in the stable-rt series. Normally I
> wait till the next development release is out before I pull in a new
> one. That is, I would pull in 3.14-rt when 3.16-rt or later was
> released. But because development is now moving at a "hobbyist rate" 
> (read http://lwn.net/Articles/617140/ for details)
> and 3.14-rt is no longer being developed against, I figured it was
time
> to put it under the "stable-rt" umbrella.

I piddled about with it yesterday, found that you can't change cpufreq
governor IFF the tree is configured as rt, but works fine as voluntary
preempt.  I'll poke about for the entertainment value.  Having no
personal need/use for rt detracts from its hobby value somewhat, but rt
problems do have a tendency to be 'entertaining'.

I'll follow up with a few patches that folks can apply to their trees if
they so desire.  There being no devel tree to submit against, I can't do
a proper submission (rules), and some of them you surely don't want :) 

	-Mike


