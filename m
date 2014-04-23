Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbaDWGHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:07:41 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:54637 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaDWGHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:07:40 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] tools lib traceevent: Options for plugins
References: <20140422194824.319892442@goodmis.org>
Date: Wed, 23 Apr 2014 15:07:38 +0900
In-Reply-To: <20140422194824.319892442@goodmis.org> (Steven Rostedt's message
	of "Tue, 22 Apr 2014 15:48:24 -0400")
Message-ID: <87ppk8r32t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Tue, 22 Apr 2014 15:48:24 -0400, Steven Rostedt wrote:
> trace-cmd has a way to set options for plugins, via the command
> line parameter. For example, you can add or remove the parent
> from being printed in function tracing by adding:
>
>   -O parent=1
>   -O parent=0
>
> This is passed later to the plugin in. But the plugin itself requires
> registering to the application what options it supplies.
>
> This is a three patch series. The first is to set a flag in pevent
> that would prevent plugins from being loaded. This can be supplied
> by the command line as well to produce the old "raw" events.
>
> The second patch adds the infrastructure to let plugins have options.
>
> The third patch adds the options "parent" and "indent" to the
> function plugin. The indent option lets the user print functions
> with or without indenting by their parents.
>
> All that needs to be done now is to add the options to the perf
> command line. Namhyung? ;-)

Well, I'll think about it, maybe next week (or later ;-p)?

Thanks,
Namhyung
