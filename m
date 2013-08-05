Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3HEIow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:44:52 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58995 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab3HEIov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:44:51 -0400
X-AuditID: 9c930179-b7c53ae000000457-12-51ff6601b5bc
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 01/13] tracing/kprobes: Move fetch functions to trace_kprobe.c
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>
	<1375261410-11219-2-git-send-email-namhyung@kernel.org>
	<51FF387B.6080505@hitachi.com>
Date: Mon, 05 Aug 2013 17:44:49 +0900
In-Reply-To: <51FF387B.6080505@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 05 Aug 2013 14:30:35 +0900")
Message-ID: <87a9kw1q7y.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Mon, 05 Aug 2013 14:30:35 +0900, Masami Hiramatsu wrote:
> (2013/07/31 18:03), Namhyung Kim wrote:
>> From: Hyeoncheol Lee <cheol.lee@lge.com>
>> 
>> Move kprobes-specific fetch functions to the trace_kprobe.c file.
>> Also define kprobes_fetch_type_table in the .c file.  This table is
>> shared with uprobes for now, but the uprobes will get its own table
>> in the later patch.
>> 
>> This is a preparation for supporting more fetch functions to uprobes
>> and no functional changes are intended.
>> 
>
> Looks good for me :)
>
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!
Namhyung
