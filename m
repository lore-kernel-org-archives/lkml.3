Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaBJIIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:08:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaBJIIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:08:46 -0500
Date: Mon, 10 Feb 2014 09:07:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 00/21] perf tools: Add support to accumulate hist
 periods (v8)
Message-ID: <20140210080744.GA1230@krava.brq.redhat.com>
References: <1391736923-30765-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391736923-30765-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:35:02AM +0900, Namhyung Kim wrote:

SNIP

> 
> 
> Namhyung Kim (21):
>   perf tools: Introduce struct hist_entry_iter
>   perf hists: Add support for accumulated stat of hist entry
>   perf hists: Check if accumulated when adding a hist entry
>   perf hists: Accumulate hist entry stat based on the callchain
>   perf tools: Update cpumode for each cumulative entry
>   perf report: Cache cumulative callchains
>   perf callchain: Add callchain_cursor_snapshot()
>   perf tools: Save callchain info for each cumulative entry
>   perf hists: Sort hist entries by accumulated period
>   perf ui/hist: Add support to accumulated hist stat
>   perf ui/browser: Add support to accumulated hist stat
>   perf ui/gtk: Add support to accumulated hist stat
>   perf tools: Apply percent-limit to cumulative percentage
>   perf tools: Add more hpp helper functions
>   perf report: Add --children option
>   perf report: Add report.children config option
>   perf tools: Add callback function to hist_entry_iter
>   perf top: Convert to hist_entry_iter
>   perf top: Add --children option
>   perf top: Add top.children config option
>   perf tools: Enable --children option by default

heya, I wasn't CC-ed ;-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

for the patchset

thanks,
jirka
