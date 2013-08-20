Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3HTOwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:52:05 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:36091 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab3HTOwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:52:01 -0400
Date: Tue, 20 Aug 2013 11:51:56 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Make command line arguments consistent with
 perf-record
Message-ID: <20130820145156.GC8488@ghostprotocols.net>
References: <1377010076-21509-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377010076-21509-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 20, 2013 at 08:47:56AM -0600, David Ahern escreveu:
> Common arguments like thread id, CPU list, mmap pages, etc should be
> consistent across perf commands.
 


> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/builtin-trace.c |   12 ++++++------

 tools/perf/Documentation/perf-trace.txt part missing :-)

>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index 4235316..9891d8c 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -693,17 +693,17 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
>  	OPT_STRING('o', "output", &output_name, "file", "output file name"),
>  	OPT_STRING('p', "pid", &trace.opts.target.pid, "pid",
>  		    "trace events on existing process id"),
> -	OPT_STRING(0, "tid", &trace.opts.target.tid, "tid",
> +	OPT_STRING('t', "tid", &trace.opts.target.tid, "tid",
>  		    "trace events on existing thread id"),
> -	OPT_BOOLEAN(0, "all-cpus", &trace.opts.target.system_wide,
> +	OPT_BOOLEAN('a', "all-cpus", &trace.opts.target.system_wide,
>  		    "system-wide collection from all CPUs"),
> -	OPT_STRING(0, "cpu", &trace.opts.target.cpu_list, "cpu",
> +	OPT_STRING('C', "cpu", &trace.opts.target.cpu_list, "cpu",
>  		    "list of cpus to monitor"),
> -	OPT_BOOLEAN(0, "no-inherit", &trace.opts.no_inherit,
> +	OPT_BOOLEAN('i', "no-inherit", &trace.opts.no_inherit,
>  		    "child tasks do not inherit counters"),
> -	OPT_UINTEGER(0, "mmap-pages", &trace.opts.mmap_pages,
> +	OPT_UINTEGER('m', "mmap-pages", &trace.opts.mmap_pages,
>  		     "number of mmap data pages"),
> -	OPT_STRING(0, "uid", &trace.opts.target.uid_str, "user",
> +	OPT_STRING('u', "uid", &trace.opts.target.uid_str, "user",
>  		   "user to profile"),
>  	OPT_CALLBACK(0, "duration", &trace, "float",
>  		     "show only events with duration > N.M ms",
> -- 
> 1.7.10.1
