Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaGLXLF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 19:11:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaGLXK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 19:10:58 -0400
Date: Sun, 13 Jul 2014 01:10:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/11] perf, tools, test: Add test case for alias and
 JSON parsing
Message-ID: <20140712231005.GB29028@krava.redhat.com>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
 <1405123165-22666-11-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405123165-22666-11-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 04:59:24PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a simple test case to perf test that runs perf download and parses
> all the available events, including json events.
> 
> This needs adding an all event iterator to pmu.c
> 
> v2: Rename identifiers
> v3: Only iterate cpu pmu to avoid bogus errors.
> Move pmu iterator to extra patch
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Makefile.perf        | 1 +
>  tools/perf/tests/builtin-test.c | 4 ++++
>  tools/perf/tests/tests.h        | 1 +
>  3 files changed, 6 insertions(+)
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 0600425..6adb37f 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -419,6 +419,7 @@ endif
>  LIB_OBJS += $(OUTPUT)tests/code-reading.o
>  LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
>  LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
> +LIB_OBJS += $(OUTPUT)tests/aliases.o

missing the tests/aliases.o file

  AR       libperf.a
ar: tests/aliases.o: No such file or directory


jirka
