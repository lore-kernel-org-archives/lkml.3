Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3FZRKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:10:47 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49242 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3FZRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:10:46 -0400
Message-ID: <51CB208A.6080403@gmail.com>
Date: Wed, 26 Jun 2013 11:10:34 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
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
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org> <1372230862-15861-6-git-send-email-namhyung@kernel.org>
In-Reply-To: <1372230862-15861-6-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/13 1:14 AM, Namhyung Kim wrote:
> +	const char * const ftrace_usage[] = {
> +		"perf ftrace [<options>] [<command>]",
> +		"perf ftrace [<options>] -- <command> [<options>]",
> +		NULL
> +	};
> +	const struct option ftrace_options[] = {
> +	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
> +		   "tracer to use"),

How does a user know what is a valid tracer string?

David
