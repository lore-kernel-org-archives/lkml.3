Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaICIsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:48:04 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:52443 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbaICIsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:48:00 -0400
Date: Wed, 3 Sep 2014 10:47:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: amit.shah@redhat.com, bobby.prani@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/urgent] Fix for 3.17
Message-ID: <20140903084755.GB8021@gmail.com>
References: <20140903034346.GA17003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903034346.GA17003@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This series contains a single commit fixing an initialization bug
> reported by Amit Shah and fixed by Pranith Kumar (and tested by Amit).
> This bug results in a boot-time hang in callback-offloaded configurations
> where callbacks were posted before the offloading ("rcuo") kthreads
> were created.  This has been exposed to -next testing, and is available
> in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent
> 
> for you to fetch changes up to 11ed7f934cb807f26da09547b5946c2e534d1dac:
> 
>   rcu: Make nocb leader kthreads process pending callbacks after spawning (2014-08-28 05:59:59 -0700)
> 
> ----------------------------------------------------------------
> Pranith Kumar (1):
>       rcu: Make nocb leader kthreads process pending callbacks after spawning
> 
>  kernel/rcu/tree.h        |  2 +-
>  kernel/rcu/tree_plugin.h | 22 +++++++++++-----------
>  2 files changed, 12 insertions(+), 12 deletions(-)

Pulled into tip:core/urgent, thanks a lot Paul!

	Ingo
