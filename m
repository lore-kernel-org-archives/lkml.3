Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3HaGA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 02:00:59 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36930 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3HaGA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 02:00:57 -0400
Date: Sat, 31 Aug 2013 08:00:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130831060054.GB28176@gmail.com>
References: <1377079825-19057-1-git-send-email-eranian@google.com>
 <1377079825-19057-3-git-send-email-eranian@google.com>
 <20130822105109.GI31370@twins.programming.kicks-ass.net>
 <CABPqkBQUqNX4W8UVzbJ6sB=JVbMY=ZJgYbRLRHX3DnvCz6SOsw@mail.gmail.com>
 <20130830140841.GS31370@twins.programming.kicks-ass.net>
 <CABPqkBRnBsw6eMbWbe3tgOo8BQyiORjvtATw33+jAvXB7LRQOg@mail.gmail.com>
 <CABPqkBRZtDHUnurzgLby8UdtTjm3BxMUJyJUr_dM-0_egTXfXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRZtDHUnurzgLby8UdtTjm3BxMUJyJUr_dM-0_egTXfXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> False alarm, the changes in builtin-inject.c are in V2. Nothing more to 
> do. Sorry about the confusion.

ok, I'll pick up the -v2 patches from Peter.

Thanks,

	Ingo
