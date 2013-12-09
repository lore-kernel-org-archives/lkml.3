Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab3LIXZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:25:35 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34961 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3LIXZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:25:34 -0500
Message-ID: <52A65169.2030705@gmail.com>
Date: Mon, 09 Dec 2013 16:25:29 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/2] perf tools: Add --header/--header-only options
References: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Stephane given that he added the header output]

On 12/9/13, 3:02 AM, Jiri Olsa wrote:
> Currently the perf.data header is always displayed for stdio
> output, which is no always useful.
>
> Disabling header information by default and adding following
> options to control header output:
>    --header      - display header information (old default)
>    --header-only - display header information only w/o further
>                    processing.
>
> thanks,
> jirka
>
>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>   tools/perf/Documentation/perf-report.txt |  6 ++++++
>   tools/perf/Documentation/perf-script.txt |  6 ++++++
>   tools/perf/builtin-report.c              | 19 ++++++++++++++++---
>   tools/perf/builtin-script.c              | 13 ++++++++++---
>   4 files changed, 38 insertions(+), 6 deletions(-)
>

I've been getting annoyed but that as well. Very useful on the first 
run; overhead after that.

Acked-by: David Ahern <dsahern@gmail.com>

