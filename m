Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbaFQSXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:23:23 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:61162 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaFQSXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:23:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140617171001.GG4669@linux.vnet.ibm.com>
References: <539FAE21.7070702@gmail.com> <20140617145419.GE4669@linux.vnet.ibm.com>
 <CAJKcOGdUDwdmdkpd0dw5xO9+TK=9W9fvF9Q+f5F_b4R8cEgdTA@mail.gmail.com> <20140617171001.GG4669@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 17 Jun 2014 14:22:50 -0400
Message-ID: <CAJhHMCB57G6LSFTX8pjoHKNKYv4ND1=8bhFWai0UxT-N-tQHdg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: simplify force_quiescent_state()
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Romanov Arya <romanov.arya@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        torvalds <torvalds@linux-foundation.org>, Waiman.Long@hp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 1:10 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:

>
> Pranith, Romanov:  You do -not-, repeat -not-, get to shoot from the hip
> with this code.  You absolutely need to understand what it is doing and
> why before you try hacking on it.  Otherwise, all that will happen is
> that you will come up with additional creative ways to break RCU.  Your
> commit log and comments will need to clearly indicate that you understand
> what happens if (say) 4096 CPUs all call force_quiescent_state() at the
> same time.
>

I do apologize for the noise I am causing.
I totally agree that I need to understand what exactly is happening
before I propose to do anything. I am trying to understand how all
this works by asking questions. I did try looking at why the locks
were there and spent quite some time trying to figure it out looking
at the history, but could not entirely get it. Hence the RFC.

Thank you for patiently considering and replying to my RFCs.

Regards,
-- 
Pranith
