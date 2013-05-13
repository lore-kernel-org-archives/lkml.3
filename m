Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3EMNmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:42:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab3EMNmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:42:50 -0400
Date: Mon, 13 May 2013 15:42:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 12/14] perf ftrace: Use pager for displaying result
Message-ID: <20130513134227.GB1032@krava.brq.redhat.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366705872-12132-13-git-send-email-namhyung@kernel.org>
 <20130424141724.GH971@krava.brq.redhat.com>
 <877gjr9k8q.fsf@sejong.aot.lge.com>
 <20130426084023.GB1054@krava.brq.redhat.com>
 <87ip2w98nl.fsf@sejong.aot.lge.com>
 <20130506113819.GB1093@krava.brq.redhat.com>
 <871u9i81ih.fsf@sejong.aot.lge.com>
 <20130510090405.GA1040@krava.brq.redhat.com>
 <87txm75khp.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txm75khp.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 05:53:22PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Fri, 10 May 2013 11:04:05 +0200, Jiri Olsa wrote:
> > On Wed, May 08, 2013 at 02:49:10PM +0900, Namhyung Kim wrote:
> > yep, that did it.. seems I'm getting the ftrace output
> > all the time, with:
> 
> Hmm.. this was just a debug patch.  So can you get the ftrace output
> without this patch too?  I suspect there's an unknown problem regarding
> stdio behind my back otherwise.

I guess, but I cannot reproduce now even with or without
the patch.. aarghh ;) strange

I'll retry whatever new respin you'll do..

jirka
