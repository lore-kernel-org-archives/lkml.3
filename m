Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3I0C1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:27:15 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:65098 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3I0C1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:27:12 -0400
X-AuditID: 9c930179-b7c8bae000006c65-a7-5244ecff137f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Add missing -ldl for gtk build
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
Date: Fri, 27 Sep 2013 11:27:11 +0900
In-Reply-To: <1380221754-29865-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 26 Sep 2013 20:55:54 +0200")
Message-ID: <8761tnov7k.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013 20:55:54 +0200, Jiri Olsa wrote:
> If we build perf with NO_LIBPYTHON=1 NO_LIBPERL=1 the '-ldl'
> is not added to libs build fails if we have gtk2 code in,
> because it depends on it.

Argh... Thanks for fixing this!

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
