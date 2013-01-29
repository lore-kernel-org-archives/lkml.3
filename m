Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3A2GFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:05:50 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53178 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab3A2GFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:05:46 -0500
X-AuditID: 9c930179-b7d01ae000004006-9a-510766b79740
From: Namhyung Kim <namhyung@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: move scheduler sysctl bits into dedicated header file
References: <20130128143120.1b60bfb6@redhat.com>
Date: Tue, 29 Jan 2013 15:05:43 +0900
In-Reply-To: <20130128143120.1b60bfb6@redhat.com> (Clark Williams's message of
	"Mon, 28 Jan 2013 14:31:20 -0600")
Message-ID: <87vcagv808.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clark,

On Mon, 28 Jan 2013 14:31:20 -0600, Clark Williams wrote:
> Move all the scheduler sysctl-related bits out of include/linux/sched.h
> into a new file include/linux/sched_sysctl.h.
>
> Signed-off-by: Clark Williams <williams@redhat.com>
> ---
[snip]
> diff --git a/include/linux/sched_sysctl.h b/include/linux/sched_sysctl.h
> new file mode 100644
> index 0000000..912adab
> --- /dev/null
> +++ b/include/linux/sched_sysctl.h
> @@ -0,0 +1,121 @@
> +#ifndef _SCHED_SYSCTL_H
> +#define _SCHED_SYSCTL_H
> +
> +
> +/* provide a home for sysctl scheduler tuning knobs */
> +
> +/*
> + * default timeslice is 100 msecs (used only for SCHED_RR tasks).
> + * Timeslices get refilled after they expire.
> + */
> +#define RR_TIMESLICE		(100 * HZ / 1000)

It seems this line came from sched.h but I can't find that part
deleted.

Thanks
Namhyung
