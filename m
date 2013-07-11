Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3GKLnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:43:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab3GKLnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:43:32 -0400
Date: Thu, 11 Jul 2013 13:43:05 +0200
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
Subject: Re: [PATCH 15/19] perf tools: Add document for perf-ftrace command
Message-ID: <20130711114305.GA1056@krava.brq.redhat.com>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
 <1372230862-15861-16-git-send-email-namhyung@kernel.org>
 <20130710142218.GB5931@krava.brq.redhat.com>
 <87y59dwluq.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y59dwluq.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 05:18:37PM +0900, Namhyung Kim wrote:
> On Wed, 10 Jul 2013 16:22:19 +0200, Jiri Olsa wrote:
> > On Wed, Jun 26, 2013 at 04:14:18PM +0900, Namhyung Kim wrote:
> >> From: Namhyung Kim <namhyung.kim@lge.com>
> >> 
> >> Cc: Steven Rostedt <rostedt@goodmis.org>
> >> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> >> ---
> >
> > SNIP
> >
> >> +OPTIONS
> >> +-------
> >> +<command>...::
> >> +	Any command you can specify in a shell.
> >> +
> >> +-t::
> >> +--tracer=::
> >> +        The ftrace tracer to be used (default: function_graph).
> >> +	Currently only 'function' and 'function_graph' are supported.
> >> +        Used by 'live' and 'record' subcommands only.
> >
> > hum, 'live' subcommand  supports whatever is available in
> > 'available_tracers' file, right?
> >
> > and displays whatever gets into 'trace' .. which I think
> > is useful and should stay like that
> 
> Agreed.  How about this?
> 
> 	The ftrace tracer to be used (default: function_graph).
> 	Currently, only 'function' and 'function_graph' are
> 	supported by 'record' command. 'live' command accepts
> 	any available tracer in system and outputs trace result
> 	directly from the ftrace's trace_pipe.

sounds good

jirka
