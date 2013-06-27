Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3F0FEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:04:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54847 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3F0FEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:04:32 -0400
X-AuditID: 9c930179-b7cafae000004567-d3-51cbc7deefef
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/19] perf tools: Introduce new 'ftrace' tool
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	<1372230862-15861-6-git-send-email-namhyung@kernel.org>
	<51CB208A.6080403@gmail.com>
Date: Thu, 27 Jun 2013 14:04:30 +0900
In-Reply-To: <51CB208A.6080403@gmail.com> (David Ahern's message of "Wed, 26
	Jun 2013 11:10:34 -0600")
Message-ID: <87ip1016w1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 26 Jun 2013 11:10:34 -0600, David Ahern wrote:
> On 6/26/13 1:14 AM, Namhyung Kim wrote:
>> +	const char * const ftrace_usage[] = {
>> +		"perf ftrace [<options>] [<command>]",
>> +		"perf ftrace [<options>] -- <command> [<options>]",
>> +		NULL
>> +	};
>> +	const struct option ftrace_options[] = {
>> +	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
>> +		   "tracer to use"),
>
> How does a user know what is a valid tracer string?

The helpline should look like (at least):

  "tracer to use: function_graph or function"

I'll update it in the next spin.

Thanks,
Namhyung
