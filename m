Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3ILFpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:45:44 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62683 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3ILFpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:45:42 -0400
Date: Thu, 12 Sep 2013 07:45:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/5] perf/urgent fixes
Message-ID: <20130912054538.GA24785@gmail.com>
References: <1378836722-31326-1-git-send-email-acme@infradead.org>
 <20130911055503.GB15395@gmail.com>
 <20130911140822.GD1866@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911140822.GD1866@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Wed, Sep 11, 2013 at 07:55:03AM +0200, Ingo Molnar escreveu:
> >  16645 perf_event_open(0x1eb7f00, 0xffffffff, 0, 0xffffffff, 0) = -1 EINVAL (Invalid argument)
> > 
> > Caused by:
> > 
> >  575a9aab0f85 perf tools: Add attr->mmap2 support
> > 
> > We must not force mmap2 support to be present on the kernel side - new 
> > perf top should work on older kernels just as well.
> > 
> > So I've unpulled the tree for now.
> 
> yeah, I noticed this late yesterday, made it to work like the fallback
> for perf_event_attr.{sample_id_all,exclude_{guest,host}} and folded that
> into Stephane's patch, with a committer note, to keep things bisectable.
> 
> Can you please do a test pull with the updated branch + tag below? If
> you prefer me to do the whole dance and send a regular pull request,
> please let me now.

Pulled, thanks a lot Arnaldo! 'perf top' works fine here now on older 
kernels as well.

	Ingo
