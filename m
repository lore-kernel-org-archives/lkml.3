Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3EFB5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 21:57:17 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52523 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3EFB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 21:57:16 -0400
X-AuditID: 9c930197-b7c1fae000001854-78-51870dfae855
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/14] perf ftrace: Add 'record' sub-command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366705872-12132-10-git-send-email-namhyung@kernel.org>
	<20130424141241.GG971@krava.brq.redhat.com>
	<87bo939lgt.fsf@sejong.aot.lge.com> <517A84B2.40209@gmail.com>
Date: Mon, 06 May 2013 10:57:13 +0900
In-Reply-To: <517A84B2.40209@gmail.com> (David Ahern's message of "Fri, 26 Apr
	2013 07:44:18 -0600")
Message-ID: <87ehdk98g6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, 26 Apr 2013 07:44:18 -0600, David Ahern wrote:
> On 4/25/13 12:24 AM, Namhyung Kim wrote:
>> But it looks there's a race between cond_wait() and cond_broatcast().
>> I'll take a look at that.
>
> Why not use eventfd or a pipe for the signalling instead?

Thanks for your feedback!

I didn't have an idea of using eventfd for this case.  Does it helpful
to prevent such a deadlock like this?

Thanks,
Namhyung
