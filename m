Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaAOCYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:24:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:35801 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752024AbaAOCYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:24:23 -0500
Date: Tue, 14 Jan 2014 21:24:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 05/17] tools lib traceevent: Make plugin unload function
 receive pevent
Message-ID: <20140114212420.69120c1f@gandalf.local.home>
In-Reply-To: <1389750340-15965-6-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-6-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 10:45:28 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> The PEVENT_PLUGIN_UNLOADER function might need some cleanup using
> pevent like unregister some handlers.  So pass pevent as argument.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

> ---
>  tools/lib/traceevent/event-parse.h     | 7 ++++---
>  tools/lib/traceevent/event-plugin.c    | 4 ++--
>  tools/lib/traceevent/plugin_function.c | 2 +-
>  tools/perf/util/trace-event.c          | 2 +-
>  4 files changed, 8 insertions(+), 7 deletions(-)
> 


