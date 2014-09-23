Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaIWKBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:01:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:59900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaIWKBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:01:31 -0400
Date: Tue, 23 Sep 2014 12:01:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>, Miao Xie <miaox@cn.fujitsu.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] sched: add macros to define bitops for task
 atomic flags
Message-ID: <20140923100127.GE3312@worktop.programming.kicks-ass.net>
References: <542124D3.9000007@huawei.com>
 <542124FB.4030109@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542124FB.4030109@huawei.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 03:44:59PM +0800, Zefan Li wrote:
> This will simplify code when we add new flags.
> 
> v3:
> - Kees pointed out that no_new_privs should never be cleared, so we
> shouldn't define task_clear_no_new_privs(). we define 3 macros instead
> of a single one.
> 
> v2:
> - updated scripts/tags.sh, suggested by Peter.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
