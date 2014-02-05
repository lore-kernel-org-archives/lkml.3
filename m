Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbaBEBmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:42:09 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39834 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaBEBmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:42:07 -0500
Message-ID: <52F196E7.6040306@hitachi.com>
Date: Wed, 05 Feb 2014 10:41:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: Re: [PATCHSET 0/5] tracing/uprobes: Support multi buffer and event
 trigger
References: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/17 17:08), Namhyung Kim wrote:
> Hello,
> (Resending with LKML CC'ed)
> 
> This patchset tries to add support for recent multi buffer and event
> trigger changes to uprobes.  The multi buffer support patch is an
> updated version of Zovi's previous patch v6 [1].
> 
> Zovi, please tell me if you have any update and/or issues with this.
> 
> Masami and Oleg, I kept your Reviewed-by's in the patch since I think
> it's just an rebase.  Please take a look again to see whether I added
> some mistakes.

OK, this series looks good to me. Thank you for enhancing it!
Feel free to add my reviewed-by.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks,

> 
> 
> You can also get it from 'uprobe/trigger-v1' branch in my tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Any comments are welcome, thanks
> Namhyung
> 
> 
> [1] https://lkml.org/lkml/2013/7/4/165
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Tom Zanussi <tom.zanussi@linux.intel.com>                          
> 
> 
> Namhyung Kim (4):
>   tracing/uprobes: Rename uprobe_{trace,perf}_print() functions
>   tracing/uprobes: Move argument fetching to uprobe_dispatcher()
>   tracing/uprobes: Support event triggering
>   tracing/uprobes: Support mix of ftrace and perf
> 
> zhangwei(Jovi) (1):
>   tracing/uprobes: Support ftrace_event_file base multibuffer
> 
>  kernel/trace/trace_kprobe.c |  17 ----
>  kernel/trace/trace_probe.h  |  17 ++++
>  kernel/trace/trace_uprobe.c | 191 +++++++++++++++++++++++++++++++-------------
>  3 files changed, 151 insertions(+), 74 deletions(-)
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


