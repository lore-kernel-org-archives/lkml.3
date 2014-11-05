Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaKEQIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:08:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:37773 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbaKEQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:08:02 -0500
Date: Wed, 5 Nov 2014 17:07:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Juerg Haefliger <juergh@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [ANNOUNCE] 3.14.23-rt20
In-Reply-To: <1415202259.5402.90.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.11.1411051707410.4245@nanos>
References: <20141031170326.1491a63f@gandalf.local.home>  <1414913427.5380.110.camel@marge.simpson.net>  <CADLDEKvFvw7Aa98tVtM3z5JV8oocKqAdV4PqOMoZH2mXZ6x2jg@mail.gmail.com>  <20141105092707.7c9bb1ae@gandalf.local.home>  <CADLDEKsYzpN4uPD7wEE6bxZP21gd3xY4c0fsRqfB1RwEZ53iKg@mail.gmail.com>
  <20141105100056.152fd532@gandalf.local.home> <1415202259.5402.90.camel@marge.simpson.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Mike Galbraith wrote:
> On Wed, 2014-11-05 at 10:00 -0500, Steven Rostedt wrote: 
> > On Wed, 5 Nov 2014 15:43:24 +0100
> > Juerg Haefliger <juergh@gmail.com> wrote:
> > 
> > > Thanks for the explanation. So is this considered a temporary failure
> > > until multiple readers are allowed or does cpufreq need fixing or
> > > something else? Just trying to figure out what to do next.
> > 
> > Good question. Unfortunately I don't know the answer to that.
> 
> [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
> 
> The above springs to mind.

Shudder!

