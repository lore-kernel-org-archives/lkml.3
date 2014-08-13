Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaHMMtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaHMMtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:49:40 -0400
Date: Wed, 13 Aug 2014 14:49:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCHSET 00/13] perf tools: Fix vmlinux search path
 initialization
Message-ID: <20140813124925.GF2370@krava.brq.redhat.com>
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 03:40:32PM +0900, Namhyung Kim wrote:

SNIP

> Thanks,
> Namhyung
> 
> 
> Namhyung Kim (13):
>   perf script: Fix possible memory leaks
>   perf tools: Fix a memory leak in vmlinux_path__init()
>   perf annotate: Move session handling out of __cmd_annotate()
>   perf buildid-cache: Move session handling into cmd_buildid_cache()
>   perf inject: Move session handling out of __cmd_inject()
>   perf kmem: Move session handling out of __cmd_kmem()
>   perf kvm: Move call to symbol__init() after creating session
>   perf lock: Move call to symbol__init() after creating session
>   perf sched: Move call to symbol__init() after creating session
>   perf script: Move call to symbol__init() after creating session
>   perf timechart: Move call to symbol__init() after creating session
>   perf trace: Move call to symbol__init() after creating session
>   perf tools: Check recorded kernel version when finding vmlinux

apart from that issue found by Adrian

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
