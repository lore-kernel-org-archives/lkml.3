Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3LTBFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:05:21 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64023 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3LTBFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:05:20 -0500
X-AuditID: 9c93017e-b7c17ae000003961-87-52b397cd4bf8
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to kprobes
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
	<1387168336-13213-11-git-send-email-namhyung@kernel.org>
	<20131218152338.56c10937@gandalf.local.home>
	<87d2ktfg5q.fsf@sejong.aot.lge.com>
	<20131219091830.5719b195@gandalf.local.home>
Date: Fri, 20 Dec 2013 10:05:17 +0900
In-Reply-To: <20131219091830.5719b195@gandalf.local.home> (Steven Rostedt's
	message of "Thu, 19 Dec 2013 09:18:30 -0500")
Message-ID: <87zjnwe3hu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Thu, 19 Dec 2013 09:18:30 -0500, Steven Rostedt wrote:
> On Thu, 19 Dec 2013 16:34:09 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> Hi Steve,
>> 
>> On Wed, 18 Dec 2013 15:23:38 -0500, Steven Rostedt wrote:
>> > On Mon, 16 Dec 2013 13:32:09 +0900
>> > Namhyung Kim <namhyung@kernel.org> wrote:
>> >
>> >> index 5395d37e5e72..adc9ac70fd3c 100644
>> >> --- a/kernel/trace/trace_uprobe.c
>> >> +++ b/kernel/trace/trace_uprobe.c
>> >> @@ -115,6 +115,14 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
>> >>  #define fetch_stack_string_size	NULL
>> >>  
>> >>  
>> >> +/* uprobes don't support symbol fetch methods */
>> >
>> > "uprobes does not support symbol fetch methods"
>> 
>> I was confused since the "uprobes" looks like a plural..
>> 
>
> Heh, yeah I guess it can be. I was thinking of it as singular. I was
> thinking of ftrace, perf, kprobes, uprobes, all being the same. As in
> "kprobes system" or "uprobes system". I implicitly added in my mind
> "system" to that sentence.
>
>  uprobes (system) does not support fetch methods
>
> But I guess one can think of it as each individual uprobe does not
> support fetch methods, so "uprobes do not support fetch methods" would
> then be correct.
>
> But still, I would use the full "do not" as the "don't" here just
> sounds funny to me (sounds like a boxer talking "Dey don't do dat to
> me! Dey don't support fetch methods either!")

Okay, will use "do not" in the next version (if needed :) ).

Thanks,
Namhyung
