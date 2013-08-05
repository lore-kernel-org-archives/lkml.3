Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3HEIvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:51:42 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42836 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3HEIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:51:41 -0400
X-AuditID: 9c930179-b7c53ae000000457-68-51ff679bca04
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 13/13] tracing/probes: Fix basic print type functions
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>
	<1375261410-11219-14-git-send-email-namhyung@kernel.org>
	<51FF4492.8080100@hitachi.com>
Date: Mon, 05 Aug 2013 17:51:39 +0900
In-Reply-To: <51FF4492.8080100@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 05 Aug 2013 15:22:10 +0900")
Message-ID: <87siyozfj8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Aug 2013 15:22:10 +0900, Masami Hiramatsu wrote:
> (2013/07/31 18:03), Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The print format of s32 type was "ld" and it's casted to "long".  So
>> it turned out to print 4294967295 for "-1" on 64-bit systems.  Not
>> sure whether it worked well on 32-bit systems.
>> 
>> Anyway, it'd be better if we have exact format and type cast for each
>> types on both of 32- and 64-bit systems.  In fact, the only difference
>> is on s64/u64 types.
>
> Thank you for fixing this :)
> But, again, this should be at the first place on the series,
> so that we can push this to stable tree too.

Okay, I'll move it to earlier in the series.

Thanks,
Namhyung
