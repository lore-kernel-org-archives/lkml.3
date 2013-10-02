Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3JBTi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:38:57 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62932 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3JBTiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:38:55 -0400
MIME-Version: 1.0
In-Reply-To: <20131002190001.GX3081@twins.programming.kicks-ass.net>
References: <20131002124610.GD28601@twins.programming.kicks-ass.net>
	<CABPqkBQyCfz5d+SQxDwPD5m52ofE6y5HKur+s-F0s=hN00cxkw@mail.gmail.com>
	<20131002130143.GF28601@twins.programming.kicks-ass.net>
	<CABPqkBTdWZaJzv4PA3yBor+o_iaBSmK73CrUQeY1tANR36ah8Q@mail.gmail.com>
	<20131002133759.GH28601@twins.programming.kicks-ass.net>
	<CAGXu5jLd3yw+RasWgMg_JJPhsfiM+hVhMru4gfkXmAcn7asEdw@mail.gmail.com>
	<CABPqkBTeJarBCkVBMGex+g32ak8vzH__x1V0aq4c22dyWJKhGA@mail.gmail.com>
	<CAGXu5jJPtfXd47fG2OR5MW1tZ_MMrv5s5NR9nMvnhnFvcuNWtA@mail.gmail.com>
	<CABPqkBR428rdck2Q6_HZAKHeWg3qc5W3nXZchnew1V7oDq+Z2Q@mail.gmail.com>
	<CAGXu5jLPJRCX2G31khiMyn5eRuAMchF=k3j0qH0MdL7mXUCCrg@mail.gmail.com>
	<20131002190001.GX3081@twins.programming.kicks-ass.net>
Date: Wed, 2 Oct 2013 12:38:54 -0700
X-Google-Sender-Auth: MZqAotOU2JsGW6WSMVUZ4ggDpWw
Message-ID: <CAGXu5jKK+BJnbzJy0pZxVG2BdgxdJ5vNChMRUAJdKrGaHCOsNg@mail.gmail.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 12:00 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Oct 02, 2013 at 11:10:15AM -0700, Kees Cook wrote:
>> Seems like a simple enough solution. Surely there must be a catch. :)
>
> I didn't want to add this to the core mm just for perf..

It seems like it would be pretty inexpensive. It might also be
valuable in other situations. Not that I can think of any at the
moment. Additionally, it could likely be hidden by a CONFIG, so that
if perf isn't built in, there's no change?

-Kees

-- 
Kees Cook
Chrome OS Security
