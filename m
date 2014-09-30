Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaI3H5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:57:12 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48564 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaI3H5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:57:07 -0400
Date: Tue, 30 Sep 2014 00:57:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] locktorture: Torture rwlocks
Message-ID: <20140930075700.GQ5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14093007-1344-0000-0000-000004908D49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 06:14:22AM -0700, Davidlohr Bueso wrote:
> We are still missing the ability to torture rwlocks, particularly the
> new queued variant (patch 1). The rest of the patches are miscellaneous
> updates.
> 
> Hopefully the set is straightforward enough that it can still be
> considered for v3.18.

Queued, thank you!

Running a quick set of tests, if these pass, will send a pull request along.

							Thanx, Paul

> Davidlohr Bueso (4):
>   locktorture: Support rwlocks
>   locktorture: Fix __acquire annotation for spinlock irq
>   locktorture: Cannot hold read and write lock
>   locktorture: Cleanup header usage
> 
>  Documentation/locking/locktorture.txt              |   5 +
>  kernel/locking/locktorture.c                       | 141 ++++++++++++++++++---
>  .../selftests/rcutorture/configs/lock/CFLIST       |   1 +
>  .../selftests/rcutorture/configs/lock/LOCK04       |   6 +
>  .../selftests/rcutorture/configs/lock/LOCK04.boot  |   1 +
>  5 files changed, 137 insertions(+), 17 deletions(-)
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot
> 
> -- 
> 1.8.4.5
> 

