Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaIWQ60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:58:26 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:33576 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbaIWQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:58:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140923100127.GE3312@worktop.programming.kicks-ass.net>
References: <542124D3.9000007@huawei.com>
	<542124FB.4030109@huawei.com>
	<20140923100127.GE3312@worktop.programming.kicks-ass.net>
Date: Tue, 23 Sep 2014 09:58:23 -0700
X-Google-Sender-Auth: BLRxdOtyxjyd2Nlm2HkLnRjpa3I
Message-ID: <CAGXu5jLjAtHUZsLW0S4SPaKtx__P-fgeCQqD6naKYVtJ_9b9Eg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] sched: add macros to define bitops for task atomic flags
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Miao Xie <miaox@cn.fujitsu.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 3:01 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Sep 23, 2014 at 03:44:59PM +0800, Zefan Li wrote:
>> This will simplify code when we add new flags.
>>
>> v3:
>> - Kees pointed out that no_new_privs should never be cleared, so we
>> shouldn't define task_clear_no_new_privs(). we define 3 macros instead
>> of a single one.

Thanks! This looks good to me.

>>
>> v2:
>> - updated scripts/tags.sh, suggested by Peter.
>>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Miao Xie <miaox@cn.fujitsu.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Signed-off-by: Zefan Li <lizefan@huawei.com>
>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
