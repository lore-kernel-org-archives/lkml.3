Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaAOFyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:54:31 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49170 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaAOFy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:54:29 -0500
X-AuditID: 9c930179-b7c84ae000000e38-20-52d6229359d8
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf tools: Do proper comm override error handling
References: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
	<1389713836-13375-2-git-send-email-fweisbec@gmail.com>
Date: Wed, 15 Jan 2014 14:54:27 +0900
In-Reply-To: <1389713836-13375-2-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Tue, 14 Jan 2014 16:37:14 +0100")
Message-ID: <8761plaiy4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Tue, 14 Jan 2014 16:37:14 +0100, Frederic Weisbecker wrote:
> The comm overriding API ignores memory allocation failures by silently
> keeping the previous and out of date comm.
>
> As a result, the user may get buggy events without ever being notified
> about the problem and its source.
>
> Lets start to fix this by propagating the error from the API. Not all
> callers may be doing proper error handling on comm set yet but this
> is the first step toward it.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
