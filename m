Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3JHItL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:49:11 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43052 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab3JHItH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:49:07 -0400
Date: Tue, 8 Oct 2013 10:49:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 49/50] tools/perf/build: Fix O=/some/dir perf.o type of
 targets
Message-ID: <20131008084903.GD3295@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-50-git-send-email-mingo@kernel.org>
 <20131007223323.GH2900@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007223323.GH2900@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Oct 07, 2013 at 01:56:42PM +0200, Ingo Molnar wrote:
> 
> SNIP
> 
> > diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
> > index eaa477f..86a4ba8 100644
> > --- a/tools/perf/Documentation/Makefile
> > +++ b/tools/perf/Documentation/Makefile
> > @@ -1,3 +1,5 @@
> > +$(info Documentation/Makefile)
> > +
> >  include ../../scripts/Makefile.include
> >  include ../config/utilities.mak
> 
> debug leftover?

Yes, fixed.

I'll do a resend of the final result, there's been enough changes to the 
whole series.

Thanks a lot for the review!

	Ingo
