Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3LPTiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:38:10 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:55263 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3LPTiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:38:08 -0500
Date: Mon, 16 Dec 2013 16:38:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, namhyung@kernel.org, artagnon@gmail.com,
        jolsa@redhat.com
Subject: Re: [PATCH 0/5] perf timechart improvements part 2
Message-ID: <20131216193800.GA19283@ghostprotocols.net>
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 02, 2013 at 06:37:32PM +0400, Stanislav Fomichev escreveu:
> This patch series has the following features:
> - adds backtrace info to the CPU overview chart
> - adds pid info to the figures on CPU overview chart
> - we now read number of CPUs from the perf.data header (this makes CPU overview
>   more accurate since it shows idle cores)
> - adds '-t' option to sort CPUs (on the CPU overview chart) topologically (draw
>   adjacent SMT threads next to each other)
> - adds '-e' option to highlight long events on the CPU overview chart
> 
> Stanislav Fomichev (5):
>   perf timechart: add backtrace support to CPU info
>   perf timechart: print pid along the name
>   perf timechart: get number of CPUs from perf header
>   perf timechart: add support for topology

>   perf timechart: add emphasize option

This one, 5/5, didn't made it to me or the mailing list, can you resend?

- Arnaldo

> 
>  tools/perf/Documentation/perf-timechart.txt |   7 ++
>  tools/perf/builtin-timechart.c              |  79 ++++++++++++--
>  tools/perf/util/svghelper.c                 | 159 ++++++++++++++++++++++++++--
>  tools/perf/util/svghelper.h                 |   6 +-
>  4 files changed, 235 insertions(+), 16 deletions(-)
> 
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
