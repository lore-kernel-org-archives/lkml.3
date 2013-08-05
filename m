Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3HEI6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:58:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50384 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3HEI6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:58:39 -0400
X-AuditID: 9c930179-b7c53ae000000457-fb-51ff693e18fc
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 02/13] tracing/kprobes: Add fetch{,_size} member into symbol and deref fetch method
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>
	<1375261410-11219-3-git-send-email-namhyung@kernel.org>
	<51FF6026.7090409@hitachi.com>
Date: Mon, 05 Aug 2013 17:58:38 +0900
In-Reply-To: <51FF6026.7090409@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 05 Aug 2013 17:19:50 +0900")
Message-ID: <87k3k0zf7l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Aug 2013 17:19:50 +0900, Masami Hiramatsu wrote:
> (2013/07/31 18:03), Namhyung Kim wrote:
>> From: Hyeoncheol Lee <cheol.lee@lge.com>
>> 
>> Those symbol and deref fetch methods access a memory region but they
>> assume it's a kernel memory since uprobes does not support them.
>> 
>> Add ->fetch and ->fetch_size member in order to provide a proper
>> access method for supporting uprobes.
>
> It looks symbol cache is not used by uprobes. I think it it enough to
> add fetch/fetch_size to only deref, isn't it?

Right.  I will change it in the next spin.

Thanks,
Namhyung
