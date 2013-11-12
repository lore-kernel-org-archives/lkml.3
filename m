Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3KLMbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:31:39 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45562 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab3KLMbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:31:35 -0500
Date: Tue, 12 Nov 2013 21:31:14 +0000
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] perf trace: Fix segfault on perf trace -i perf.data
Message-ID: <20131112213114.GB14439@danjae>
References: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
 <1384237500-22991-2-git-send-email-namhyung@kernel.org>
 <20131112114609.GB4053@ghostprotocols.net>
 <20131112115700.GC4053@ghostprotocols.net>
 <20131112121508.GE4053@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131112121508.GE4053@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 09:15:08AM -0300, Arnaldo Carvalho de Melo wrote:
> Second part, just rewrote the changelog a bit:
> 
> commit 4e8a6e566fc611b9cbec2978a52266f29cb65785
> Author: Namhyung Kim <namhyung.kim@lge.com>
> Date:   Tue Nov 12 15:25:00 2013 +0900
> 
>     perf trace: Fix segfault on perf trace -i perf.data
>     
>     When replaying a previous record session, it'll get a segfault since it
>     doesn't initialize raw_syscalls enter/exit tracepoint's evsel->priv for
>     caching the format fields.
>     
>     So fix it by properly initializing sys_enter/exit evsels that comes from
>     reading the perf.data file header.

Looks good to me!

Thanks for doing this, Arnaldo.  I'll try to avoid this kind of thing
again in the future.

Thanks,
Namhyung
