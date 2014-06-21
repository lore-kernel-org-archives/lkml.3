Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaFUMTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:19:24 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41531 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaFUMTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:19:23 -0400
Message-ID: <53A57848.8010203@gmail.com>
Date: Sat, 21 Jun 2014 20:19:20 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/trace/syscall.h: Use HAVE_SYSCALL_TRACEPOINTS
 instead of TRACEPOINTS
References: <53A4EEC5.7090801@gmail.com> <20140620234308.25a57690@gandalf.local.home>
In-Reply-To: <20140620234308.25a57690@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2014 11:43 AM, Steven Rostedt wrote:
> On Sat, 21 Jun 2014 10:32:37 +0800
> Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>  
>> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
>> index 291c282..a709cbd 100644
>> --- a/include/trace/syscall.h
>> +++ b/include/trace/syscall.h
>> @@ -33,7 +33,7 @@ struct syscall_metadata {
>>  	struct ftrace_event_call *exit_event;
>>  };
>>  
>> -#ifdef CONFIG_TRACEPOINTS
>> +#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
>>  static inline void syscall_tracepoint_update(struct task_struct *p)
>>  {
>>  	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> 
> This has already been fixed and is in my for-next branch getting ready
> to be pushed.
> 

OK, thank you for replying in time.


Thanks.
-- 
Open share and attitude like air warter and life which God blessed
