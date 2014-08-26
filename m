Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbaHZIDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:03:10 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:38953 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934005AbaHZIDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:03:03 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2] perf tools: Add +field argument support for --sort option
References: <1408715919-25990-1-git-send-email-jolsa@kernel.org>
	<1408715919-25990-3-git-send-email-jolsa@kernel.org>
	<20140822151651.GC3473@kernel.org>
	<20140822152354.GB22315@krava.brq.redhat.com>
	<20140823125948.GA1193@krava.brq.redhat.com>
Date: Tue, 26 Aug 2014 17:02:58 +0900
In-Reply-To: <20140823125948.GA1193@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sat, 23 Aug 2014 14:59:48 +0200")
Message-ID: <87fvgjbrv1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sat, 23 Aug 2014 14:59:48 +0200, Jiri Olsa wrote:
> Adding support to add field(s) to default sort order
> via using the '+' prefix, like for report:
>
>   $ perf report
>   Samples: 2K of event 'cycles', Event count (approx.): 882172583
>   Overhead  Command          Shared Object                Symbol
>      7.39%  swapper          [kernel.kallsyms]            [k] intel_idle
>      1.97%  firefox          libpthread-2.17.so           [.] pthread_mutex_lock
>      1.39%  firefox          [snd_hda_intel]              [k] azx_get_position
>      1.11%  firefox          libpthread-2.17.so           [.] pthread_mutex_unlock
>
>   $ perf report -s +cpu
>   Samples: 2K of event 'cycles', Event count (approx.): 882172583
>   Overhead  Command          Shared Object                Symbol                      CPU
>      2.89%  swapper          [kernel.kallsyms]            [k] intel_idle              000
>      2.61%  swapper          [kernel.kallsyms]            [k] intel_idle              002
>      1.20%  swapper          [kernel.kallsyms]            [k] intel_idle              001
>      0.82%  firefox          libpthread-2.17.so           [.] pthread_mutex_lock      002
>
> Works in general for commands using --sort option.
>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
