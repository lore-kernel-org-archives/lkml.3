Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaGCMjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:39:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:31115 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752589AbaGCMjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:39:11 -0400
Date: Thu, 3 Jul 2014 08:39:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH RT 0/4] Linux 3.12.22-rt35-rc1
Message-ID: <20140703083908.54a82e5e@gandalf.local.home>
In-Reply-To: <1404365326.5137.76.camel@marge.simpson.net>
References: <20140702171414.482562827@goodmis.org>
	<1404365326.5137.76.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2014 07:28:46 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> 
> On Wed, 2014-07-02 at 13:14 -0400, Steven Rostedt wrote: 
> > Dear RT Folks,
> > 
> > This is the RT stable review cycle of patch 3.12.22-rt35-rc1.
> > 
> > Please scream at me if I messed something up. Please test the patches too.
> 
> [PATCH RT 5/4] sched: Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq() ?
> 

Is that in 3.14-rt yet? I didn't see it. As with stable mainline,
nothing goes into stable-rt until it is in -rt upstream.

-- Steve
