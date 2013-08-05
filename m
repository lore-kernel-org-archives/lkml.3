Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3HEItn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:49:43 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51905 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3HEItm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:49:42 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-63-51ff67244bc7
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 04/13] tracing/kprobes: Factor out struct trace_probe
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>
	<1375261410-11219-5-git-send-email-namhyung@kernel.org>
	<51FF3F79.6090202@hitachi.com>
Date: Mon, 05 Aug 2013 17:49:40 +0900
In-Reply-To: <51FF3F79.6090202@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 05 Aug 2013 15:00:25 +0900")
Message-ID: <871u681pzv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Aug 2013 15:00:25 +0900, Masami Hiramatsu wrote:
> (2013/07/31 18:03), Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> There are functions that can be shared to both of kprobes and uprobes.
>> Separate common data structure to struct trace_probe and use it from
>> the shared functions.
>
> Thanks, basically I'm good at this change.

Thanks!

> Could you also rename several functions which handles trace_kprobe
> instead of trace_probe? (as you did on trace_probe_XXX())

Sure, I'll change them all.

Thanks,
Namhyung
