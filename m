Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3HEIuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:50:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57984 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3HEIuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:50:24 -0400
X-AuditID: 9c930179-b7c53ae000000457-92-51ff674d636d
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 06/13] tracing/kprobes: Move common functions to trace_probe.c
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>
	<1375261410-11219-7-git-send-email-namhyung@kernel.org>
	<51FF4044.4080703@hitachi.com>
Date: Mon, 05 Aug 2013 17:50:21 +0900
In-Reply-To: <51FF4044.4080703@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 05 Aug 2013 15:03:48 +0900")
Message-ID: <87wqo0zfle.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Aug 2013 15:03:48 +0900, Masami Hiramatsu wrote:
> (2013/07/31 18:03), Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The __get_data_size() and store_trace_args() will be used by uprobes
>> too.  Move them to a common location.
>
> Hmm, could you move this into trace_probe.h? Since this will
> be used in fast path, I'd like to keep it as inlined.

Will do.

Thanks,
Namhyung
