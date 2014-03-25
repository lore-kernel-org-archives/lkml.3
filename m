Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaCYFsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 01:48:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60235 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaCYFst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 01:48:49 -0400
Date: Tue, 25 Mar 2014 06:48:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL rcu/next] Additional RCU commit for 3.15
Message-ID: <20140325054845.GA27206@gmail.com>
References: <20140325041638.GA23624@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325041638.GA23624@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> And, if you are willing to take it, one late-breaking commit.  This one
> was requested for 3.15 by Peter Zijlstra. [...]

No objections at all, looks like a useful facility!

> [...] It is low risk because it adds a new in-kernel API with 
> minimal changes to the existing code.  Those minimal changes are the 
> addition of memory barriers and ACCESS_ONCE() macro calls, neither 
> of which should be able to break things.  This commit has passed 
> significant rcutorture testing, with these additional additions to 
> rcutorture slated for 3.16.  This commit has also been exposed to 
> -next testing.
> 
> This change is available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> for you to fetch changes up to 765a3f4fed708ae429ee095914a7897acb3a65bd:
> 
>   rcu: Provide grace-period piggybacking API (2014-03-20 17:12:25 -0700)
> 
> ----------------------------------------------------------------
> Paul E. McKenney (1):
>       rcu: Provide grace-period piggybacking API
> 
>  include/linux/rcutiny.h | 10 ++++++++
>  include/linux/rcutree.h |  2 ++
>  kernel/rcu/tree.c       | 62 +++++++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 70 insertions(+), 4 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
