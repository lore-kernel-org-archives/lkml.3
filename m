Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114Ab3GSBlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 21:41:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61860 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625Ab3GSBlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 21:41:04 -0400
Message-ID: <51E898FB.2000006@huawei.com>
Date: Fri, 19 Jul 2013 09:40:11 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing: use trace_seq_puts()/trace_seq_putc() where
 possible
References: <51E3B3AC.1000605@huawei.com> <1374197370.3356.8.camel@gandalf.local.home>
In-Reply-To: <1374197370.3356.8.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/19 9:29, Steven Rostedt wrote:
> On Mon, 2013-07-15 at 16:32 +0800, zhangwei(Jovi) wrote:
>> diff --git a/kernel/trace/trace_functions_graph.c
>> b/kernel/trace/trace_functions_graph.c
>> index 8388bc9..3793f90 100644
>> --- a/kernel/trace/trace_functions_graph.c
>> +++ b/kernel/trace/trace_functions_graph.c
>> @@ -446,7 +446,7 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
>>
>>         /* First spaces to align center */
>>         for (i = 0; i < spaces / 2; i++) {
>> -               ret = trace_seq_printf(s, " ");
>> +               ret = trace_seq_putc(s, ' ');
>>                 if (!ret)
>>                         return TRACE_TYPE_PARTIAL_LINE;
>>         }
>> @@ -457,7 +457,7 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
>>
>>         /* Last spaces to align center */
>>         for (i = 0; i < spaces - (spaces / 2); i++) {
>> -               ret = trace_seq_printf(s, " ");
>> +               ret = trace_seq_putc(s, " ");
> 
> Oops, s/"/'/g
> 
> I'll fix it.
> 
Sorry for this, I will open my eyes more larger next time.

jovi



