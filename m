Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3JJO06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:26:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab3JJO05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:26:57 -0400
Date: Thu, 10 Oct 2013 11:26:39 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] perf: disable mmap2 support
Message-ID: <20131010142639.GA3790@infradead.org>
References: <20131009161743.GA3022@quad>
 <52558278.6080206@gmail.com>
 <CABPqkBRx1CqwXOjJXWeqEBqkLkZMHWVQJNjv1jjqPakoDNB3Gg@mail.gmail.com>
 <CABPqkBQKaMd_LuvfUreYb_9hiR-j0BkAyiP2yP-C0TTy+15_fQ@mail.gmail.com>
 <5255900A.5050103@gmail.com>
 <CABPqkBQZz=80he07yzagwPjhJBOK-bc_C=hfsK+LjMvcYWZvew@mail.gmail.com>
 <52559A8E.1030101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52559A8E.1030101@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 09, 2013 at 12:03:58PM -0600, David Ahern escreveu:
> On 10/9/13 11:40 AM, Stephane Eranian wrote:
> >On Wed, Oct 9, 2013 at 7:19 PM, David Ahern <dsahern@gmail.com> wrote:
> >>On 10/9/13 10:39 AM, Stephane Eranian wrote:
> >You mean:
> >commit 384c671e33a7ddf905f2c60b433b9883f0e5a605
> >Author: David Ahern <dsahern@gmail.com>
> >Date:   Sun Sep 22 19:44:58 2013 -0600
> >
> >     perf trace: Add mmap2 handler
> >
> >Right?
> 
> Yes, a couple of those have 2 commit ids. I pulled the id's from
> acme's perf/core branch

I'm merging my perf/core branch with Ingo's build speedup series, so
I've removed that patch already, will be ok as soon as the disabling is
done in perf/urgent and those branches get merged.
 
- Arnaldo
