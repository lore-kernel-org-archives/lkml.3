Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab3GDGOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:14:24 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49470 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3GDGOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:14:23 -0400
Message-ID: <51D512B9.50809@hitachi.com>
Date: Thu, 04 Jul 2013 15:14:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Re: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between
 opening probe event files and deleting probe
References: <20130704033347.807661713@goodmis.org> <51D4F377.6080002@hitachi.com>
In-Reply-To: <51D4F377.6080002@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/04 13:00), Masami Hiramatsu wrote:
>> Steven Rostedt (Red Hat) (3):
>>       tracing: Add ref count to ftrace_event_call
>>       tracing/kprobes: Fail to unregister if probe event files are open
>>       tracing/uprobes: Fail to unregister if probe event files are open
> 
> I just started to look into the series, but the 3/4 and 4/4 seems same...
> Which one is good to go?

Ah, now I see, those are for kprobes and uprobes...

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


