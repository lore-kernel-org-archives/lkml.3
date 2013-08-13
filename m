Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3HMDdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 23:33:43 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63864 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab3HMDdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 23:33:42 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-65-5209a914b95d
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V10 06/13] perf tools: remove unnecessary callchain validation
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
	<1376045519-13832-7-git-send-email-adrian.hunter@intel.com>
Date: Tue, 13 Aug 2013 12:33:40 +0900
In-Reply-To: <1376045519-13832-7-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Fri, 9 Aug 2013 13:51:52 +0300")
Message-ID: <8761vaw9gr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 13:51:52 +0300, Adrian Hunter wrote:
> Now that the sample parsing correctly checks data sizes
> there is no reason for it to be done again for callchains.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
