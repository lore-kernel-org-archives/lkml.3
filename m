Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaKEPo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:44:28 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58157 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbaKEPo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:44:26 -0500
Message-ID: <1415202259.5402.90.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14.23-rt20
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juerg Haefliger <juergh@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Wed, 05 Nov 2014 16:44:19 +0100
In-Reply-To: <20141105100056.152fd532@gandalf.local.home>
References: <20141031170326.1491a63f@gandalf.local.home>
	 <1414913427.5380.110.camel@marge.simpson.net>
	 <CADLDEKvFvw7Aa98tVtM3z5JV8oocKqAdV4PqOMoZH2mXZ6x2jg@mail.gmail.com>
	 <20141105092707.7c9bb1ae@gandalf.local.home>
	 <CADLDEKsYzpN4uPD7wEE6bxZP21gd3xY4c0fsRqfB1RwEZ53iKg@mail.gmail.com>
	 <20141105100056.152fd532@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 10:00 -0500, Steven Rostedt wrote: 
> On Wed, 5 Nov 2014 15:43:24 +0100
> Juerg Haefliger <juergh@gmail.com> wrote:
> 
> > Thanks for the explanation. So is this considered a temporary failure
> > until multiple readers are allowed or does cpufreq need fixing or
> > something else? Just trying to figure out what to do next.
> 
> Good question. Unfortunately I don't know the answer to that.

[RFC PATCH RT] rwsem: The return of multi-reader PI rwsems

The above springs to mind.

-Mike

