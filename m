Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab3ENBDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:03:07 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59704 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3ENA6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:58:53 -0400
X-AuditID: 9c93017e-b7cf8ae000004f65-54-51918c4be154
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
	<87txm75khp.fsf@sejong.aot.lge.com>
	<20130513134227.GB1032@krava.brq.redhat.com>
Date: Tue, 14 May 2013 09:58:51 +0900
In-Reply-To: <20130513134227.GB1032@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 13 May 2013 15:42:28 +0200")
Message-ID: <87d2su5qd0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013 15:42:28 +0200, Jiri Olsa wrote:
> On Mon, May 13, 2013 at 05:53:22PM +0900, Namhyung Kim wrote:
>> Hi Jiri,
>> 
>> On Fri, 10 May 2013 11:04:05 +0200, Jiri Olsa wrote:
>> > On Wed, May 08, 2013 at 02:49:10PM +0900, Namhyung Kim wrote:
>> > yep, that did it.. seems I'm getting the ftrace output
>> > all the time, with:
>> 
>> Hmm.. this was just a debug patch.  So can you get the ftrace output
>> without this patch too?  I suspect there's an unknown problem regarding
>> stdio behind my back otherwise.
>
> I guess, but I cannot reproduce now even with or without
> the patch.. aarghh ;) strange
>
> I'll retry whatever new respin you'll do..

Okay, thanks.  I'll respin it soon.

Thanks,
Namhyung
