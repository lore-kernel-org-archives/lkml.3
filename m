Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaIXOJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:09:31 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:41569 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaIXOJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:09:30 -0400
To: tj@kernel.org
Cc: lizefan@huawei.com, peterz@infradead.org, mingo@kernel.org,
        keescook@chromium.org, miaox@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        rientjes@google.com
Subject: Re: [PATCH v3 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <542124D3.9000007@huawei.com>
	<20140924132218.GC16555@htj.dyndns.org>
	<20140924133513.GD16555@htj.dyndns.org>
In-Reply-To: <20140924133513.GD16555@htj.dyndns.org>
Message-Id: <201409242309.HDF95877.OSVFFtQLJMOHOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 24 Sep 2014 23:09:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> > Applied 1-3 to cgroup/for-3.17-fixes w/ the typo spotted by davidr
> > fixed.

s/happend/happened/

> 
> Reverted due to build failure.  Will wait for a refreshed version. :(

I can build with 1-3 patches using HEAD of linux.git. What failure did you see?

$ make kernel/seccomp.o kernel/sys.o security/apparmor/domain.o kernel/cpuset.o
