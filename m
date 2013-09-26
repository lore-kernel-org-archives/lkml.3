Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab3IZN7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:59:48 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52736 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3IZN7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:59:47 -0400
Subject: Re: [PATCH] perf: fix infinite loop with corrupted header
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20130926134640.GA26159@ghostprotocols.net>
References: <1380172836-13936-1-git-send-email-sonnyrao@chromium.org>
	 <52443800.5080200@gmail.com>  <20130926134640.GA26159@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 22:59:37 +0900
Message-ID: <1380203977.1810.0.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-09-26 (목), 10:46 -0300, Arnaldo Carvalho de Melo:
> Em Thu, Sep 26, 2013 at 07:34:56AM -0600, David Ahern escreveu:
> > On 9/25/13 11:20 PM, Sonny Rao wrote:
> > >We recently ran into a corrupt perf data file which mostly looked okay
> > >but the section size for data was set to 0.  This caused perf report to
> > >get into an infinite loop in __perf_session_process_events().  Let's
> > >just avoid this by bailing early and reporting it if there's an
> > >invalid header.
> > 
> > Been suggested before:
> > https://lkml.org/lkml/2013/5/9/405
> 
> Thanks for the pointer (and this latest patch as well), looking at it
> now.
> 
> - Arnaldo
>  
> > Other changes went in around that time as well. Are you still seeing
> > the loop on latest source?

Did you mean this?

https://lkml.org/lkml/2013/5/9/670


Thanks,
Namhyung


