Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3JJGlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:41:51 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56029 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3JJGlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:41:49 -0400
Date: Thu, 10 Oct 2013 08:41:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 44/52] tools/perf/build: Clean up various testcases
Message-ID: <20131010064146.GA10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-45-git-send-email-mingo@kernel.org>
 <87ob6xir4i.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob6xir4i.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue,  8 Oct 2013 12:11:14 +0200, Ingo Molnar wrote:
> > --- a/tools/perf/config/feature-checks/test-gtk2.c
> > +++ b/tools/perf/config/feature-checks/test-gtk2.c
> > @@ -4,7 +4,7 @@
> >  
> >  int main(int argc, char *argv[])
> >  {
> > -        gtk_init(&argc, &argv);
> > +	gtk_init(&argc, &argv);
> >  
> >          return 0;
> >  }
> 
> Whitespace damaged.

What I think this patch does is to _remove_ the whitespace damage that was 
present in the previous feature-tests.mak method.

This hunk changes spaces to tabs.

Agreed?

Thanks,

	Ingo
