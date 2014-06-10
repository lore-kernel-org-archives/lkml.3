Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbaFJHPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:15:03 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56779 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793AbaFJHPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:15:01 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf timechart: fix documentation
References: <1402305672-2630-1-git-send-email-stfomichev@yandex-team.ru>
	<1402305672-2630-2-git-send-email-stfomichev@yandex-team.ru>
Date: Tue, 10 Jun 2014 16:14:58 +0900
In-Reply-To: <1402305672-2630-2-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Mon, 9 Jun 2014 13:21:11 +0400")
Message-ID: <87bnu1b5hp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

On Mon,  9 Jun 2014 13:21:11 +0400, Stanislav Fomichev wrote:
> Move options away from examples.

I think it's better to move RECORD OPTIONS as well.

Thanks,
Namhyung


>
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/Documentation/perf-timechart.txt | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
> index bc5990c33dc0..fab20d4504d2 100644
> --- a/tools/perf/Documentation/perf-timechart.txt
> +++ b/tools/perf/Documentation/perf-timechart.txt
> @@ -43,6 +43,17 @@ TIMECHART OPTIONS
>  
>  --symfs=<directory>::
>          Look for files with symbols relative to this directory.
> +-n::
> +--proc-num::
> +        Print task info for at least given number of tasks.
> +-t::
> +--topology::
> +        Sort CPUs according to topology.
> +--highlight=<duration_nsecs|task_name>::
> +	Highlight tasks (using different color) that run more than given
> +	duration or tasks with given name. If number is given it's interpreted
> +	as number of nanoseconds. If non-numeric string is given it's
> +	interpreted as task name.
>  
>  EXAMPLES
>  --------
> @@ -64,18 +75,6 @@ Record system-wide timechart:
>  
>    $ perf timechart --highlight gcc
>  
> --n::
> ---proc-num::
> -        Print task info for at least given number of tasks.
> --t::
> ---topology::
> -        Sort CPUs according to topology.
> ---highlight=<duration_nsecs|task_name>::
> -	Highlight tasks (using different color) that run more than given
> -	duration or tasks with given name. If number is given it's interpreted
> -	as number of nanoseconds. If non-numeric string is given it's
> -	interpreted as task name.
> -
>  RECORD OPTIONS
>  --------------
>  -P::
