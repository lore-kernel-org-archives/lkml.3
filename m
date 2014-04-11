Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaDKDZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 23:25:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:8500 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751462AbaDKDZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 23:25:45 -0400
Date: Thu, 10 Apr 2014 23:25:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140410232542.23ee9920@gandalf.local.home>
In-Reply-To: <1397184626.5139.24.camel@marge.simpson.net>
References: <20140409151922.5fa5d999@gandalf.local.home>
	<1397139510.5137.92.camel@marge.simpson.net>
	<1397140123.5137.99.camel@marge.simpson.net>
	<1397184626.5139.24.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014 04:50:26 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> Oh, there was another useful bit. 
> 
> 3.12.17-rt25       403991     384216     377786
>                    405466     394011     392850
> 
> 3.12.17-nopreempt  109049     186133     118766  !?!.. ew, TTWU_QUEUE
>                    350385     318786     367336  !TTWU_QUEUE
>                    326009     356939     378215  !TTWU_QUEUE
> 
> IPI == low-pass filter.

I'm sorry, but I don't have the foggiest clue to what the above means.

-- Steve
