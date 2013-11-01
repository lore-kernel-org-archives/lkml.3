Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3KAHiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:38:16 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:51371 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3KAHiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:38:14 -0400
Date: Fri, 1 Nov 2013 08:38:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/5] perf tools: Enhance option parsing error message
Message-ID: <20131101073811.GE21471@gmail.com>
References: <1383291195-24386-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383291195-24386-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi,
> 
> This patchset tries to enhance error message when perf failed to parse
> option argument.  Currently it just shows entire usage and options
> which may fill two pages of screen.  It's hard for me to say it's
> really helpful to users. ;-)
> 
> With this patch series, it changed to show only related option(s).
> There're also more points to improve yet - like auto-breaking long
> lines, dealing with UIs and so on.  But I believe this will be a good
> start.
> 
>   $ perf report -g help
> 
>    usage: perf report [<options>]
> 
>       -g, --call-graph <output_type,min_percent[,print_limit],call_order>
>                           Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). Default: fractal,0.5,callee,function
> 
>   $ perf stat -Bx, ls
>   -B option not supported with -x
> 
>    usage: perf stat [<options>] [<command>]
> 
>       -B, --big-num         print large numbers with thousands' separators
>       -x, --field-separator <separator>
>                             print counts with custom separator
> 
> 
> You can get this on 'perf/option-v1' branch in my tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Cool!

Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Enthusiastically-Supported-by: Ingo Molnar <mingo@kernel.org>
/me runs out of tags

Thanks!

	Ingo
