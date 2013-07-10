Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3GJOmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:42:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab3GJOmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:42:14 -0400
Date: Wed, 10 Jul 2013 16:41:48 +0200
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
Subject: Re: [PATCH 10/19] perf ftrace: Add 'show' sub-command
Message-ID: <20130710144147.GD5931@krava.brq.redhat.com>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
 <1372230862-15861-11-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372230862-15861-11-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 04:14:13PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The ftrace show subcommand is for viewing recorded ftrace files.  It
> enters perf.data.dir directory and open perf.header file to find out
> necessary information.  And then read out per-cpu trace records using
> kbuffer helper and print them to stdout in time order.
> 
> It only shows its basic form so function graph doesn't show duration/
> overhead and no leaf entry handling is provided yet.  Maybe it can be
> handled by a proper plugin in the libtraceevent.
> 

[jolsa@krava perf]$ sudo ./perf ftrace show -i perf.data.dir/
failed to open perf.data.dir/.dir/perf.header: No such file or directory

I'd expect any directory name is possible

jirka
