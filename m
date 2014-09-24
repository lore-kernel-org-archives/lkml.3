Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaIXNWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:22:31 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:48339 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIXNW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:22:29 -0400
Date: Wed, 24 Sep 2014 09:22:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>, Miao Xie <miaox@cn.fujitsu.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Message-ID: <20140924132218.GC16555@htj.dyndns.org>
References: <542124D3.9000007@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542124D3.9000007@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 03:44:19PM +0800, Zefan Li wrote:
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
> because it is used as bit number. Redefine it as decimal bit number.
> 
> Note this changes the bit position of PFA_NOW_NEW_PRIVS from 1 to 0.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Acked-by: Kees Cook <keescook@chromium.org>
> [ lizf: slightly modified subject and changelog ]
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied 1-3 to cgroup/for-3.17-fixes w/ the typo spotted by davidr
fixed.

Thanks.

-- 
tejun
