Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaGNIAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:00:13 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60997 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaGNIAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:00:08 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, acme@redhat.com
Subject: Re: [PATCH 4/4] perf record: add new -I option to sample interrupted machine state
References: <1404857759-25105-1-git-send-email-eranian@google.com>
	<1404857759-25105-5-git-send-email-eranian@google.com>
Date: Mon, 14 Jul 2014 17:00:05 +0900
In-Reply-To: <1404857759-25105-5-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Wed, 9 Jul 2014 00:15:59 +0200")
Message-ID: <87a98c2wvu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Wed,  9 Jul 2014 00:15:59 +0200, Stephane Eranian wrote:
> Add -I option to capture machine state registers at interrupt.

You need to add it in the Documentation too.

Thanks,
Namhyung


>
> Use perf report -D to display the sampled register values 
> in each sample.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/builtin-record.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 378b85b..17c45f8 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -876,6 +876,8 @@ const struct option record_options[] = {
>  		    "sample transaction flags (special events only)"),
>  	OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
>  		    "use per-thread mmaps"),
> +	OPT_BOOLEAN('I', "sample-intr-regs", &record.opts.sample_intr_regs,
> +		    "Sample machine register on interrupt"),
>  	OPT_END()
>  };
