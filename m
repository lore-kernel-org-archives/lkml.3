Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3EQOjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:39:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab3EQOjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:39:41 -0400
Date: Fri, 17 May 2013 16:39:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/9] perf hists: Move locking to its call-sites
Message-ID: <20130517143916.GE3848@krava.brq.redhat.com>
References: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
 <1368497347-9628-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368497347-9628-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 11:09:02AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It's a preparation patch to eliminate unneeded locking in the perf
> report path.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 26 ++++++++++++++------------
>  tools/perf/builtin-top.c    |  3 +++
>  tools/perf/util/hist.c      |  6 +-----
>  3 files changed, 18 insertions(+), 17 deletions(-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
