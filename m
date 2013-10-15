Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab3JONfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:35:07 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49601 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab3JONfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:35:06 -0400
Date: Tue, 15 Oct 2013 15:34:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] perf: disable mmap2 support
Message-ID: <20131015133459.GA14476@gmail.com>
References: <20131009161743.GA3022@quad>
 <52558278.6080206@gmail.com>
 <CABPqkBRx1CqwXOjJXWeqEBqkLkZMHWVQJNjv1jjqPakoDNB3Gg@mail.gmail.com>
 <CABPqkBQKaMd_LuvfUreYb_9hiR-j0BkAyiP2yP-C0TTy+15_fQ@mail.gmail.com>
 <5255900A.5050103@gmail.com>
 <CABPqkBQZz=80he07yzagwPjhJBOK-bc_C=hfsK+LjMvcYWZvew@mail.gmail.com>
 <52584626.4050000@gmail.com>
 <CABPqkBRX1Qg5s7CKh++gxu4dq+GV0YZp30ixeF9-AmHoec8Gaw@mail.gmail.com>
 <20131015131231.GD2402@gmail.com>
 <CABPqkBQN6Qn-Ccpjg09OzOv=LeT2S-Rr=sb2VVaJh0opfnyuYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQN6Qn-Ccpjg09OzOv=LeT2S-Rr=sb2VVaJh0opfnyuYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Tue, Oct 15, 2013 at 3:12 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> >> Arnaldo,
> >>
> >> Could you revert all the mmap2 patches in your perf/urgent tree for now?
> >> Thanks.
> >
> > I think it would be helpful if you re-sent the final patch, with a full
> > changelog, etc., in a separate thread, not inside an existing discussion
> > and such.
>
> Are you talking about the perf tool or kernel patch?

Both.

> I did not send any perf-related mmap2 revert patches.

Would be nice to have a single patch that reverts both.

Thanks,

	Ingo
