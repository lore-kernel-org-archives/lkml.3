Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3JYLZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:25:09 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:36314 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3JYLZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131024075813.GA26929@gmail.com>
References: <20131024075813.GA26929@gmail.com>
Date: Fri, 25 Oct 2013 13:25:05 +0200
X-Google-Sender-Auth: DM4osC9-GQcXN957hIIuBk1SmiI
Message-ID: <CAOJsxLHBZgUB1dSyF=qx2jfMHGs2sfgO5AEgV9h1KSuxejoEXQ@mail.gmail.com>
Subject: Re: ktap inclusion in drivers/staging/?
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jovi.zhangwei@huawei.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 9:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
>  - In a similar fashion, it would be nice to see it integrated with
>    'perf probe' or 'perf ktap', so that users can create probes from
>    a single place, with coherent syntax and integrated analysis
>    capabilities. I.e. there's no reason to not make this a
>    relatively pain-less yet very useful transition.

I really hope we don't end up wit 'perf ktap'. As a user, I really don't want
to know what the underlying mechanism is nor learn the command line
idiosyncrasies, I just want to 'perf trace'.

                        Pekka
