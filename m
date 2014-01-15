Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaAOGYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:24:51 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:63910 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaAOGYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:24:49 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-88-52d629b0bdfb
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf tools: Remove unnecessary callchain cursor state restore on unmatch
References: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
	<1389713836-13375-4-git-send-email-fweisbec@gmail.com>
Date: Wed, 15 Jan 2014 15:24:47 +0900
In-Reply-To: <1389713836-13375-4-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Tue, 14 Jan 2014 16:37:16 +0100")
Message-ID: <87txd592z4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 16:37:16 +0100, Frederic Weisbecker wrote:
> If a new callchain branch doesn't match a single entry of the node that
> it is given against comparison in append_chain(), then the cursor is
> expected to be at the same position as it was before the comparison loop.
>
> As such, there is no need to restore the cursor position on exit in case
> of non matching branches.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
