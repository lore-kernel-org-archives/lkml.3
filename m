Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaCQEje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:39:34 -0400
Received: from ozlabs.org ([203.10.76.45]:53836 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaCQEjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:39:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFA][PATCH 3/4] tracing/module: Remove include of tracepoint.h from module.h
In-Reply-To: <20140226221335.3e30572a@gandalf.local.home>
References: <20140226190140.590029589@goodmis.org> <20140226190644.730153889@goodmis.org> <20140226221335.3e30572a@gandalf.local.home>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 17 Mar 2014 13:04:55 +1030
Message-ID: <87fvmhtuwg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> On Wed, 26 Feb 2014 14:01:43 -0500
> Hi Rusty,
>
> This patch doesn't need to be stable, and can wait till v3.15. But I
> have other patches that will break with this patch (headers that needed
> to include tracepoint.h and not depend on a header chain to include it).
>
> Can you give me your Acked-by for this, and I'll just add it to my 3.15
> queue?

Cleaning up old mail, in case I didn't ack this:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>  include/linux/module.h | 1 -
>>  1 file changed, 1 deletion(-)
>> 
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index eaf60ff..6cc28d9 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -15,7 +15,6 @@
>>  #include <linux/stringify.h>
>>  #include <linux/kobject.h>
>>  #include <linux/moduleparam.h>
>> -#include <linux/tracepoint.h>
>>  #include <linux/export.h>
>>  
>>  #include <linux/percpu.h>
