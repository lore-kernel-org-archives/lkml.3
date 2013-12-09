Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab3LINpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:45:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933693Ab3LINpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:45:01 -0500
Date: Mon, 9 Dec 2013 14:44:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/4] perf tools: Pedantic fixes for mmap_pages
Message-ID: <20131209134444.GB30360@krava.brq.redhat.com>
References: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 03:18:36PM +0200, Adrian Hunter wrote:
> Hi
> 
> Here are some pedantic fixes for mmap_pages.
> 
> 
> Adrian Hunter (4):
>       perf tools: Remove unnecessary parentheses
>       perf tools: Fix max mmap_pages
>       perf tools: Fix mmap pages rounding to power of 2
>       perf tools: Fix display of incorrect mmap pages
> 
>  tools/perf/builtin-record.c |  2 +-
>  tools/perf/util/evlist.c    | 10 ++++++----
>  tools/perf/util/util.h      | 12 ++++++++++++
>  3 files changed, 19 insertions(+), 5 deletions(-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
