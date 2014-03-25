Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaCYJaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:30:15 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47567 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaCYJaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:30:14 -0400
Message-ID: <53314C9D.1060802@hitachi.com>
Date: Tue, 25 Mar 2014 18:30:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 12/26] ftrace/*probes: Allow probing on some functions
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305120007.22766.71082.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140324153830.72f17c4b@gandalf.local.home>
In-Reply-To: <20140324153830.72f17c4b@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/25 4:38), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 21:00:07 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> --- a/kernel/trace/trace_kprobe.c
>> +++ b/kernel/trace/trace_kprobe.c
>> @@ -1209,7 +1209,7 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
>>   * kprobe_trace_self_tests_init() does enable_trace_probe/disable_trace_probe
>>   * lockless, but we can't race with this __init function.
>>   */
>> -static __kprobes
>> +static
>>  int kprobe_register(struct ftrace_event_call *event,
> 
> Please keep the static on the same line as int. Either the above is one
> line or:
> 
> static int
> kprobe_register(...)
> 
> Like the rest of the patch does.

I see, I'll update it. :)

Thank you,

> 
> -- Steve
> 
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


