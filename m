Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3LSHeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:34:12 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44156 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LSHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:34:11 -0500
X-AuditID: 9c93016f-b7cc5ae000007121-d0-52b2a1715524
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
Date: Thu, 19 Dec 2013 16:34:09 +0900
In-Reply-To: <20131218152338.56c10937@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 18 Dec 2013 15:23:38 -0500")
Message-ID: <87d2ktfg5q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Wed, 18 Dec 2013 15:23:38 -0500, Steven Rostedt wrote:
> On Mon, 16 Dec 2013 13:32:09 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> index 5395d37e5e72..adc9ac70fd3c 100644
>> --- a/kernel/trace/trace_uprobe.c
>> +++ b/kernel/trace/trace_uprobe.c
>> @@ -115,6 +115,14 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
>>  #define fetch_stack_string_size	NULL
>>  
>>  
>> +/* uprobes don't support symbol fetch methods */
>
> "uprobes does not support symbol fetch methods"

I was confused since the "uprobes" looks like a plural..

Thanks,
Namhyung
