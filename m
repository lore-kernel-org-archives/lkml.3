Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3BMIrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:47:07 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44876 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3BMIrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:47:05 -0500
Date: Wed, 13 Feb 2013 09:46:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL rcu/srcu] SRCU commits for 3.9
Message-ID: <20130213084659.GA7630@gmail.com>
References: <20130212162903.GA16750@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212162903.GA16750@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This series contains SRCU changes for 3.9.  These include debugging aids,
> updates that move towards the goal of permitting srcu_read_lock() and
> srcu_read_unlock() to be used from idle and offline CPUs, and a few small
> fixes.  These commits are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/srcu
> 
> 							Thanx, Paul
> 
> -------------->
> Lai Jiangshan (8):
>       srcu: Simplify __srcu_read_unlock() via this_cpu_dec()
>       srcu: Add might_sleep() annotation to synchronize_srcu()
>       srcu: Simple cleanup for cleanup_srcu_struct()
>       srcu: Remove checks preventing offline CPUs from calling srcu_read_lock()
>       srcu: Remove checks preventing idle CPUs from calling srcu_read_lock()
>       srcu: Update synchronize_srcu()'s comments
>       srcu: Update synchronize_srcu_expedited()'s comments
>       srcu: use ACCESS_ONCE() to access sp->completed in srcu_read_lock()
> 
>  include/linux/srcu.h |   26 +++-----------------------
>  kernel/srcu.c        |   37 ++++++++++++++++---------------------
>  2 files changed, 19 insertions(+), 44 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
