Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3EQOWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab3EQOWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:22:10 -0400
Date: Fri, 17 May 2013 16:21:43 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/9] perf top: Fix -E option behavior
Message-ID: <20130517142143.GB3848@krava.brq.redhat.com>
References: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
 <1368497347-9628-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368497347-9628-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 11:08:59AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The -E/--entries option controls how many lines to be printed on stdio
> output but it doesn't work as it should be:
> 
> If -E option is specified, print that many lines regardless of current
> window size, if not automatically adjust number of lines printed to
> fit into the window size.
> 
> Reported-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Tested-by: Jiri Olsa <jolsa@redhat.com>

jirka
