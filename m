Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3EQO2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632Ab3EQO2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:28:33 -0400
Date: Fri, 17 May 2013 16:28:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/9] perf top: Get rid of *_threaded() functions
Message-ID: <20130517142817.GD3848@krava.brq.redhat.com>
References: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
 <1368497347-9628-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368497347-9628-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 11:09:01AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Those _threaded() functions are needed to make hist tree handling
> thread-safe, but AFAICS the only thing it does is forcing it to use
> the intermediate 'collapsed' tree.  It can be acheived by setting
> sort__need_collapse to 1 in cmd_top() so no need to keep those
> _threaded() variants.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-top.c | 23 +++++++++++++----------
>  tools/perf/util/hist.c   | 44 ++++++--------------------------------------
>  tools/perf/util/hist.h   |  4 ----
>  3 files changed, 19 insertions(+), 52 deletions(-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
