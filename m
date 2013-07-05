Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963Ab3GEO5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:57:39 -0400
Received: from mail-gg0-f179.google.com ([209.85.161.179]:61507 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab3GEO5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:57:37 -0400
Date: Fri, 5 Jul 2013 11:57:30 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 00/16] perf tools: Cleanups on tracepoint handling
Message-ID: <20130705145730.GC2559@ghostprotocols.net>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 04, 2013 at 02:20:15PM +0900, Namhyung Kim escreveu:
> Hello,
> 
> This patchset is a resend version of previous work and basis of
> upcoming perf ftrace patchset.  Although I saw no issue on this series
> when I posted earlier, it'd be great if Steve or others take a look at
> it again and give comments.

All seems ok, thanks a lot, applied.

- Arnaldo
