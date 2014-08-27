Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934957AbaH0OeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:34:05 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60419 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933802AbaH0OeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:34:03 -0400
Message-ID: <53FDEC51.3070301@gmail.com>
Date: Wed, 27 Aug 2014 08:33:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 8/9] perf script: Add period data column
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org> <1408977943-16594-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408977943-16594-9-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/25/14, 8:45 AM, Jiri Olsa wrote:
> Adding period data column to be displayed in perf script.
> It's possible to get period values using -f option, like:
>
>    $ perf script -f comm,tid,time,period,ip,sym,dso
>            :26019 26019 52414.329088:       3707  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
>            :26019 26019 52414.329088:         44  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
>            :26019 26019 52414.329093:       1987  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
>            :26019 26019 52414.329093:          6  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
>                ls 26019 52414.329442:     537558        3407c0639c _dl_map_object_from_fd (/usr/lib64/ld-2.17.so)
>                ls 26019 52414.329442:       2099        3407c0639c _dl_map_object_from_fd (/usr/lib64/ld-2.17.so)
>                ls 26019 52414.330181:    1242100        34080917bb get_next_seq (/usr/lib64/libc-2.17.so)
>                ls 26019 52414.330181:       3774        34080917bb get_next_seq (/usr/lib64/libc-2.17.so)
>                ls 26019 52414.331427:    1083662  ffffffff810c7dc2 update_curr ([kernel.kallsyms])
>                ls 26019 52414.331427:        360  ffffffff810c7dc2 update_curr ([kernel.kallsyms])
>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/perf/Documentation/perf-script.txt |  2 +-
>   tools/perf/builtin-script.c              | 12 +++++++++++-
>   2 files changed, 12 insertions(+), 2 deletions(-)

Acked-by: David Ahern <dsahern@gmail.com>
