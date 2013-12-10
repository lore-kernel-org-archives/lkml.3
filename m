Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab3LJAMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:12:15 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61857 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3LJAMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:12:12 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-86-52a65c5a8464
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf report: Add --header/--header-only options
References: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
	<1386583370-1699-2-git-send-email-jolsa@redhat.com>
Date: Tue, 10 Dec 2013 09:12:10 +0900
In-Reply-To: <1386583370-1699-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 9 Dec 2013 11:02:49 +0100")
Message-ID: <87ppp5lg2t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Dec 2013 11:02:49 +0100, Jiri Olsa wrote:
> Currently the perf.data header is always displayed for stdio
> output, which is no always useful.
>
> Disabling header information by default and adding following
> options to control header output:
>   --header      - display header information (old default)
>   --header-only - display header information only w/o further
>                   processing, forces stdio output
>
[SNIP]
> +--header
> +	Show perf.data header.

This explanation looks too terse.  How about this?

	Show header information in the perf.data file.  This includes
        various information like hostname, os and perf version, cpu/mem
        info, perf command line, event list and so on.  Currently only
        --stdio output supports this feature.

Thanks,
Namhyung

> +
> +--header-only
> +	Show only perf.data header (forces --stdio).
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1], linkperf:perf-annotate[1]
