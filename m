Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3F0Nv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:51:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61544 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3F0Nv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:51:57 -0400
Message-ID: <51CC4373.8000204@gmail.com>
Date: Thu, 27 Jun 2013 07:51:47 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/19] perf tools: Introduce new 'ftrace' tool
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org> <1372230862-15861-6-git-send-email-namhyung@kernel.org> <51CB208A.6080403@gmail.com> <87ip1016w1.fsf@sejong.aot.lge.com>
In-Reply-To: <87ip1016w1.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/13 11:04 PM, Namhyung Kim wrote:
> Hi David,
>
> On Wed, 26 Jun 2013 11:10:34 -0600, David Ahern wrote:
>> On 6/26/13 1:14 AM, Namhyung Kim wrote:
>>> +	const char * const ftrace_usage[] = {
>>> +		"perf ftrace [<options>] [<command>]",
>>> +		"perf ftrace [<options>] -- <command> [<options>]",
>>> +		NULL
>>> +	};
>>> +	const struct option ftrace_options[] = {
>>> +	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
>>> +		   "tracer to use"),
>>
>> How does a user know what is a valid tracer string?
>
> The helpline should look like (at least):
>
>    "tracer to use: function_graph or function"

exactly. I would suggest making that OPT_CALLBACK as well to validate 
the string content when options are parsed.

David


