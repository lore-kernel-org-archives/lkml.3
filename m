Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaAER5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:57:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaAER5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:57:09 -0500
Date: Sun, 5 Jan 2014 18:56:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 16/21] perf tools: Factor out sample__resolve_callchain()
Message-ID: <20140105175647.GL10018@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-17-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-17-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:22PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The report__resolve_callchain() can be shared with perf top code as it
> doesn't really depend on the perf report code.  Factor it out as
> sample__resolve_callchain().  The same goes to the hist_entry__append_
> callchain() too.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 22 ++--------------------
>  tools/perf/builtin-top.c    | 22 +++++++---------------
>  tools/perf/util/callchain.c | 23 +++++++++++++++++++++++
>  tools/perf/util/callchain.h |  6 ++++++
>  4 files changed, 38 insertions(+), 35 deletions(-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
