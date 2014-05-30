Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaE3HJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:09:49 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48539 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbaE3HJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:09:48 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: jolsa@redhat.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/7] perf: Add support to dynamically get cacheline size
References: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
	<1401208087-181977-7-git-send-email-dzickus@redhat.com>
Date: Fri, 30 May 2014 16:09:46 +0900
In-Reply-To: <1401208087-181977-7-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Tue, 27 May 2014 12:28:06 -0400")
Message-ID: <87vbsneo91.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 12:28:06 -0400, Don Zickus wrote:
> Different arches may have different cacheline sizes.  Look it up and set
> a global variable for reference.

[SNIP]
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 635cd8f..6e06567 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -2,6 +2,7 @@
>  #include "hist.h"
>  #include "comm.h"
>  #include "symbol.h"
> +#include "cpumap.h"

It seems not needed anymore?

Thanks,
Namhyung

>  
>  regex_t		parent_regex;
>  const char	default_parent_pattern[] = "^sys_|^do_page_fault";
