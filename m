Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaJVBgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:36:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45600 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaJVBgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:36:04 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 0/7] perf tools: Fix branch report segfaults
References: <1413468427-31049-1-git-send-email-jolsa@kernel.org>
Date: Wed, 22 Oct 2014 10:36:00 +0900
In-Reply-To: <1413468427-31049-1-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Thu, 16 Oct 2014 16:07:00 +0200")
Message-ID: <87egu0ga2n.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 16 Oct 2014 16:07:00 +0200, Jiri Olsa wrote:
> hi,
> adding some branch_info checks to prevent segfaults
> on data without branch info.
>
> v2: using cmp_null as suggested by Namhyung

For the series,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


>
> available at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/abort_fix_2
>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/sort.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 76 insertions(+), 26 deletions(-)
