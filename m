Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaGHWtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:49:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33949 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaGHWsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:48:53 -0400
Date: Tue, 8 Jul 2014 15:48:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 0/9] rcu: trivial sparse and return type fixes for rcu
Message-ID: <20140708224849.GH4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
 <CAJhHMCDUy_=LZWkhA5OU3WsfpyFwxwDJGT6rnqY3E6t=ZXQk3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCDUy_=LZWkhA5OU3WsfpyFwxwDJGT6rnqY3E6t=ZXQk3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070822-8236-0000-0000-000003AEAEF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 06:32:03PM -0400, Pranith Kumar wrote:
> This patch series contains trivial fixes for sparse warnings and using bool
> types where appropriate instead of 0/1.
> 
> I can probably merge the return type changes into one commit if you think that
> is appropriate.

Queued for 3.18, with the exception of 3/9, which I fixed up and queued
the earlier version.  I guess I should have waited a few minutes longer.  ;-)

							Thanx, Paul

> Pranith Kumar (9):
>   rcu: fix sparse warning about rcu_batches_completed_preempt(
> ) being
>     non-static
>   rcu: use bool type for return value in rcu_is_watching()
>   rcu: Fix a sparse warning about boost_mutex being non-static
>   rcu: return bool type in rcu_lockdep_current_cpu_online()
>   rcu: return bool type for rcu_try_advance_all_cbs()
>   rcu: use true/false for return in __call_rcu_nocb()
>   rcu: use true/false for return in rcu_nocb_adopt_orphan_cbs()
>   rcu: use false for return in __call_rcu_nocb()
>   rcu: use bool return type in rcu_nocb_adopt_orphan_cbs()
> 
>  include/linux/rcupdate.h |  2 +-
>  kernel/rcu/rcutorture.c  |  2 +-
>  kernel/rcu/tree.c        |  2 +-
>  kernel/rcu/tree_plugin.h | 16 ++++++++--------
>  4 files changed, 11 insertions(+), 11 deletions(-)
> 

