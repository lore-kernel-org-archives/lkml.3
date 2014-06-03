Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbaFCVu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:50:59 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:12645 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaFCVu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:50:58 -0400
Message-ID: <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [GIT PULL] locking tree changes for v3.16
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 03 Jun 2014 14:50:51 -0700
In-Reply-To: <20140603114821.GA23711@gmail.com>
References: <20140603114821.GA23711@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 13:48 +0200, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest locking-core-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-core-for-linus
> 
>    # HEAD: 3cf2f34e1a3d4d5ff209d087925cf950e52f4805 rwsem: Add comments to explain the meaning of the rwsem's count field
> 
> The main changes in this cycle were:
> 
>  - reduced/streamlined smp_mb__*() interface that allows more usecases 
>    and makes the existing ones less buggy, especially in rarer 
>    architectures
> 
>  - add rwsem implementation comments
> 
>  - bump up lockdep limits

So I guess the rwsem optimistic spinning stuff will be routed through
akpm then (which is already in -next for a while, through -mm).

Also curious about why Peter's rewrite of the qrwlock_t was removed from
-tip... I noticed it was there for a few days then disappeared. What am
I missing?

Thanks,
Davidlohr

