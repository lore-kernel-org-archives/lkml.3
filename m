Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbaGCNPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:15:37 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39296 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbaGCNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:15:35 -0400
Message-ID: <1404393329.6068.2.camel@marge.simpson.net>
Subject: Re: [PATCH RT 0/4] Linux 3.12.22-rt35-rc1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 03 Jul 2014 15:15:29 +0200
In-Reply-To: <20140703083908.54a82e5e@gandalf.local.home>
References: <20140702171414.482562827@goodmis.org>
	 <1404365326.5137.76.camel@marge.simpson.net>
	 <20140703083908.54a82e5e@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 08:39 -0400, Steven Rostedt wrote: 
> On Thu, 03 Jul 2014 07:28:46 +0200
> Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> 
> > 
> > On Wed, 2014-07-02 at 13:14 -0400, Steven Rostedt wrote: 
> > > Dear RT Folks,
> > > 
> > > This is the RT stable review cycle of patch 3.12.22-rt35-rc1.
> > > 
> > > Please scream at me if I messed something up. Please test the patches too.
> > 
> > [PATCH RT 5/4] sched: Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq() ?
> > 
> 
> Is that in 3.14-rt yet? I didn't see it. As with stable mainline,
> nothing goes into stable-rt until it is in -rt upstream.

Oh right, no, not yet.

-Mike

