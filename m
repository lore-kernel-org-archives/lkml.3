Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3BAIpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:45:23 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58340 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab3BAIpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:45:21 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-59-510b809b6710
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH 2/2] perf: add new perf uncore command
References: <1359640479-5289-1-git-send-email-eranian@google.com>
	<1359640479-5289-3-git-send-email-eranian@google.com>
Date: Fri, 01 Feb 2013 17:45:15 +0900
In-Reply-To: <1359640479-5289-3-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Thu, 31 Jan 2013 14:54:39 +0100")
Message-ID: <874nhwtobo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a nitpick.  But maybe I shows it can be done with perf stat. :)


On Thu, 31 Jan 2013 14:54:39 +0100, Stephane Eranian wrote:
> diff --git a/tools/perf/builtin-uncore.c b/tools/perf/builtin-uncore.c
> new file mode 100644
> index 0000000..b050712
> --- /dev/null
> +++ b/tools/perf/builtin-uncore.c
> @@ -0,0 +1,739 @@
> +/*
> + * builtin-stat.c

s/stat/uncore/ :)

> + *
> + * Builtin stat command: Give a precise performance counters summary

Ditto.

Thanks,
Namhyung

