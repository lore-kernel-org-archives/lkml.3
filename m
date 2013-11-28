Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab3K1Pmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:42:54 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:54606 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab3K1Pmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:42:52 -0500
MIME-Version: 1.0
In-Reply-To: <1384806771-2945-9-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com> <1384806771-2945-9-git-send-email-dsahern@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 29 Nov 2013 00:42:32 +0900
X-Google-Sender-Auth: 9wwPzQH0OybQAdFlPRnEo_TexM0
Message-ID: <CAM9d7cjSBQj9xrzE6kWM3ZVU2YzUykfPx3ag7roXZZLw9x9epg@mail.gmail.com>
Subject: Re: [PATCH 8/8] perf sched : Add documentation for timehist options
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 5:32 AM, David Ahern <dsahern@gmail.com> wrote:
> Add entry to perf-sched documentation for timehist command and its
> options.
>

> +--max-stack::
> +    Set the stack depth limit when showing the callchains. Default: 127

I think the default is 5.

> +
> +-x::
> +--excl::

The long name can be more verbose as I said.


> +    Symbols to skip in backtrace. Useful to compact repetitive or
> +    uninteresting frames to pull more useful frames into view.
> +
> +--symfs=<directory>::
> +    Look for files with symbols relative to this directory.
> +
> +-V::
> +--cpu-visual::
> +    Add a visual for following events by cpu

I think it'd be better if you elaborate it bit more. :)

Thanks,
Namhyung


> +
>  SEE ALSO
>  --------
>  linkperf:perf-record[1]
> --
> 1.8.3.4 (Apple Git-47)
>
