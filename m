Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaJIGkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:40:20 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47111 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaJIGkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:40:16 -0400
Date: Thu, 9 Oct 2014 08:40:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, dave@stgolabs.net
Subject: Re: [GIT PULL rcu/next] Additional locktorture commits for 3.18
Message-ID: <20141009064011.GB19898@gmail.com>
References: <20141004085003.GA17523@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141004085003.GA17523@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> A few additional commits for locktorture for 3.18.  These were posted
> to LKML at https://lkml.org/lkml/2014/9/29/277 and have been exposed to
> -next testing.
> 
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> for you to fetch changes up to c98fed9fc6a7449affd941d8a8e9fcb0c72977d6:
> 
>   locktorture: Cleanup header usage (2014-09-30 00:10:02 -0700)
> 
> ----------------------------------------------------------------
> Davidlohr Bueso (4):
>       locktorture: Support rwlocks
>       locktorture: Fix __acquire annotation for spinlock irq
>       locktorture: Cannot hold read and write lock
>       locktorture: Cleanup header usage
> 
>  Documentation/locking/locktorture.txt              |   5 +
>  kernel/locking/locktorture.c                       | 141 ++++++++++++++++++---
>  .../selftests/rcutorture/configs/lock/CFLIST       |   1 +
>  .../selftests/rcutorture/configs/lock/LOCK04       |   6 +
>  .../selftests/rcutorture/configs/lock/LOCK04.boot  |   1 +
>  5 files changed, 137 insertions(+), 17 deletions(-)
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot

Pulled into tip:core/rcu, thanks a lot Paul!

	Ingo
