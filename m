Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3LJAG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:06:56 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44599 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3LJAGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:06:55 -0500
X-AuditID: 9c930197-b7bdbae000000e78-e4-52a65b1d9540
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 0/2] perf tools: Add --header/--header-only options
References: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
Date: Tue, 10 Dec 2013 09:06:53 +0900
In-Reply-To: <1386583370-1699-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 9 Dec 2013 11:02:48 +0100")
Message-ID: <87txehlgbm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon,  9 Dec 2013 11:02:48 +0100, Jiri Olsa wrote:
> Currently the perf.data header is always displayed for stdio
> output, which is no always useful.
>
> Disabling header information by default and adding following
> options to control header output:

Hmm.. I'm not sure it's OK to change the user-visible default behavior.
At least we can provide help message for old users?

Thanks,
Namhyung


>   --header      - display header information (old default)
>   --header-only - display header information only w/o further
>                   processing.
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
>  tools/perf/Documentation/perf-report.txt |  6 ++++++
>  tools/perf/Documentation/perf-script.txt |  6 ++++++
>  tools/perf/builtin-report.c              | 19 ++++++++++++++++---
>  tools/perf/builtin-script.c              | 13 ++++++++++---
>  4 files changed, 38 insertions(+), 6 deletions(-)
