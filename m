Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3EMIxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:53:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61532 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3EMIxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:53:24 -0400
X-AuditID: 9c93016f-b7b9bae000002df2-5a-5190aa02d4c3
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 12/14] perf ftrace: Use pager for displaying result
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366705872-12132-13-git-send-email-namhyung@kernel.org>
	<20130424141724.GH971@krava.brq.redhat.com>
	<877gjr9k8q.fsf@sejong.aot.lge.com>
	<20130426084023.GB1054@krava.brq.redhat.com>
	<87ip2w98nl.fsf@sejong.aot.lge.com>
	<20130506113819.GB1093@krava.brq.redhat.com>
	<871u9i81ih.fsf@sejong.aot.lge.com>
	<20130510090405.GA1040@krava.brq.redhat.com>
Date: Mon, 13 May 2013 17:53:22 +0900
In-Reply-To: <20130510090405.GA1040@krava.brq.redhat.com> (Jiri Olsa's message
	of "Fri, 10 May 2013 11:04:05 +0200")
Message-ID: <87txm75khp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 10 May 2013 11:04:05 +0200, Jiri Olsa wrote:
> On Wed, May 08, 2013 at 02:49:10PM +0900, Namhyung Kim wrote:
> yep, that did it.. seems I'm getting the ftrace output
> all the time, with:

Hmm.. this was just a debug patch.  So can you get the ftrace output
without this patch too?  I suspect there's an unknown problem regarding
stdio behind my back otherwise.

Thanks,
Namhyung
