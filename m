Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab3DXKjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:39:40 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48856 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab3DXKjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:39:39 -0400
X-AuditID: 9c930197-b7bb3ae000000fa9-fe-5177b6698c9d
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 14/14] perf tools: Add document for perf-ftrace command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366705872-12132-15-git-send-email-namhyung@kernel.org>
	<1366732433.9609.153.camel@gandalf.local.home>
Date: Wed, 24 Apr 2013 19:39:37 +0900
In-Reply-To: <1366732433.9609.153.camel@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 23 Apr 2013 11:53:53 -0400")
Message-ID: <871ua0b4ba.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013 11:53:53 -0400, Steven Rostedt wrote:
> On Tue, 2013-04-23 at 17:31 +0900, Namhyung Kim wrote:
>> +  'perf ftrace live <command>' to see a live trace of kernel functions
>> +  via trace_pipe during executing the <command>.  If <command> is not
>> +  specified, one of target options (-p, -a or -C) should be given.  It
>
> one of *the* target options
>
>> +  just print out the result to stdout and doesn't save any files.
>
> just *prints* out the result

Thank you for fixing the grammar!  It's one of the hardest job for me to
write a document - even a short one. :)

Thanks,
Namhyung
