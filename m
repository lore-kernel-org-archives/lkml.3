Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaBJDP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:15:57 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63155 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaBJDP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:15:56 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 22:15:56 EST
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung.kim@lge.com
Message-ID: <52F840E6.8080406@lge.com>
Date: Mon, 10 Feb 2014 12:00:54 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 7/7] perf tools: Show absolute percentage by default
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org> <1392000446-14744-8-git-send-email-namhyung@kernel.org>
In-Reply-To: <1392000446-14744-8-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, please ignore this.  This was a leftover from last change.. sorry 
:(  (actually, it's same as patch 8/8).

Thanks,
Namhyung


2014-02-10 오전 11:47, Namhyung Kim 쓴 글:
> Now perf report will show absolute percentage on filter entries by
> default.
>
> Suggested-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   tools/perf/util/symbol.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index b888cb241164..a9d758a3b371 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -33,7 +33,6 @@ struct symbol_conf symbol_conf = {
>   	.try_vmlinux_path = true,
>   	.annotate_src	  = true,
>   	.demangle	  = true,
> -	.filter_relative  = true,
>   	.symfs            = "",
>   };
>
>
