Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3LQAQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:16:40 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50837 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3LQAQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:16:39 -0500
X-AuditID: 9c93017d-b7c5eae000004296-d6-52af97e5f4cb
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
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
	<52AEB87D.6020507@hitachi.com> <87fvptgpe0.fsf@sejong.aot.lge.com>
Date: Tue, 17 Dec 2013 09:16:37 +0900
In-Reply-To: <87fvptgpe0.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Mon, 16 Dec 2013 17:40:23 +0900")
Message-ID: <8738lsgwm2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

Would you please review this and consider merging it?  It seems there's
no more remaining issue and we want to make a progress on it. :)

Oleg, Srikar, it'd be great if you could confirm it though.

Thanks,
Namhyung


On Mon, 16 Dec 2013 17:40:23 +0900, Namhyung Kim wrote:
> Hi Masami,
>
> On Mon, 16 Dec 2013 17:23:25 +0900, Masami Hiramatsu wrote:
>> (2013/12/16 13:32), Namhyung Kim wrote:
>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>> 
>>> Move existing functions to trace_kprobe.c and add NULL entries to the
>>> uprobes fetch type table.  I don't make them static since some generic
>>> routines like update/free_XXX_fetch_param() require pointers to the
>>> functions.
>>> 
>>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>>> Cc: Oleg Nesterov <oleg@redhat.com>
>>> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
>>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>>
>> This looks good for me :)
>>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>
>> And now all of this series has been reviewed/acked by me!
>
> Thank you so much for your review! :)
>
> Thanks,
> Namhyung
