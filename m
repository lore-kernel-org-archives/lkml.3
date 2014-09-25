Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaIYCR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:17:27 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:45853 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaIYCR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:17:26 -0400
Date: Wed, 24 Sep 2014 22:17:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Miao Xie <miaox@cn.fujitsu.com>, Kees Cook <keescook@chromium.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Message-ID: <20140925021721.GA5530@mtj.dyndns.org>
References: <54237281.5020308@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54237281.5020308@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 09:40:17AM +0800, Zefan Li wrote:
> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
> because it is used as bit number. Redefine it as decimal bit number.
> 
> Note this changes the bit position of PFA_NOW_NEW_PRIVS from 1 to 0.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Acked-by: Kees Cook <keescook@chromium.org>
> [ lizf: slightly modified subject and changelog ]
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-3.17-fixes.

Thanks.

-- 
tejun
