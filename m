Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab3EFBwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 21:52:50 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55275 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3EFBwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 21:52:49 -0400
X-AuditID: 9c93016f-b7b72ae00000104b-6e-51870cee49cd
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
Date: Mon, 06 May 2013 10:52:46 +0900
In-Reply-To: <20130426084023.GB1054@krava.brq.redhat.com> (Jiri Olsa's message
	of "Fri, 26 Apr 2013 10:40:23 +0200")
Message-ID: <87ip2w98nl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013 10:40:23 +0200, Jiri Olsa wrote:
> On Thu, Apr 25, 2013 at 03:50:45PM +0900, Namhyung Kim wrote:
>> On Wed, 24 Apr 2013 16:17:24 +0200, Jiri Olsa wrote:
>> > On Tue, Apr 23, 2013 at 05:31:10PM +0900, Namhyung Kim wrote:
>> >> From: Namhyung Kim <namhyung.kim@lge.com>
>> >> 
>> >> It's convenient to use pager when seeing many lines of result.
>> >> 
>> > for some reason I'm able to get any output for 'live' command only
>> > when using --no-pager option. I dont get any data for:
>> >
>> >   # ./perf ftrace live ls
>> >
>> >   not even ls output
>
> ok, now with your patch I get allways ls output correctly in pager

"ls output" only?  What about the ftrace outputs?

>
>> >
>> > But sometime I dont even get ftrace output for:
>> >
>> >   # ./perf --no-pager ftrace live ls
>> >
>> >   just ls output
>
> this one still persists

Hmm.. still hard to reproduce.. :(

As it's --no-pager mode, so that it can be reproduced for you without
this patch, right?

Thanks,
Namhyung
