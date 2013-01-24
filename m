Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3AXNmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:42:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59451 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3AXNlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:41:55 -0500
Date: Thu, 24 Jan 2013 14:41:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v6 00/18] perf: add memory access sampling support
Message-ID: <20130124134151.GA7982@gmail.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
 <20130124115637.GA523@gmail.com>
 <CABPqkBT+9qG8Yj0w37W2YNuy5NirLtgcRg3qnZo7XDkRRwA0tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT+9qG8Yj0w37W2YNuy5NirLtgcRg3qnZo7XDkRRwA0tQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Thu, Jan 24, 2013 at 12:56 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> >> This patch series had a new feature to the kernel perf_events
> >> interface and corresponding user level tool, perf.
> >
> > Would be nice to merge this with the overlapping parts of Andi's
> > Haswell series.
>
> That's what I have now. Merged with a couple of patches from 
> Andi's. Will post update today.

Ok, great!

Thanks,

	Ingo
