Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3GKISm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:18:42 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52159 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3GKISj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:18:39 -0400
X-AuditID: 9c930179-b7c49ae000000e68-6b-51de6a5dc010
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
Subject: Re: [PATCH 15/19] perf tools: Add document for perf-ftrace command
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	<1372230862-15861-16-git-send-email-namhyung@kernel.org>
	<20130710142218.GB5931@krava.brq.redhat.com>
Date: Thu, 11 Jul 2013 17:18:37 +0900
In-Reply-To: <20130710142218.GB5931@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 10 Jul 2013 16:22:19 +0200")
Message-ID: <87y59dwluq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013 16:22:19 +0200, Jiri Olsa wrote:
> On Wed, Jun 26, 2013 at 04:14:18PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>
> SNIP
>
>> +OPTIONS
>> +-------
>> +<command>...::
>> +	Any command you can specify in a shell.
>> +
>> +-t::
>> +--tracer=::
>> +        The ftrace tracer to be used (default: function_graph).
>> +	Currently only 'function' and 'function_graph' are supported.
>> +        Used by 'live' and 'record' subcommands only.
>
> hum, 'live' subcommand  supports whatever is available in
> 'available_tracers' file, right?
>
> and displays whatever gets into 'trace' .. which I think
> is useful and should stay like that

Agreed.  How about this?

	The ftrace tracer to be used (default: function_graph).
	Currently, only 'function' and 'function_graph' are
	supported by 'record' command. 'live' command accepts
	any available tracer in system and outputs trace result
	directly from the ftrace's trace_pipe.


Thanks,
Namhyung
