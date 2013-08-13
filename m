Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab3HMDjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 23:39:15 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58507 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015Ab3HMDjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 23:39:14 -0400
X-AuditID: 9c930197-b7b44ae00000347f-02-5209aa5f14ed
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V10 09/13] perf tools: move perf_evlist__config() to a new source file
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
	<1376045519-13832-10-git-send-email-adrian.hunter@intel.com>
Date: Tue, 13 Aug 2013 12:39:10 +0900
In-Reply-To: <1376045519-13832-10-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Fri, 9 Aug 2013 13:51:55 +0300")
Message-ID: <87wqnquun5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 13:51:55 +0300, Adrian Hunter wrote:
> perf_evlist__config() must be moved to a separate source
> file to avoid Python link errors when adding support for
> PERF_SAMPLE_IDENTIFIER.
>
> It is appropriate to do this because perf_evlist__config()
> is a helper function for event recording.  It is used by
> tools to apply recording options to perf_evlist.  It is
> not used by the Python API.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
