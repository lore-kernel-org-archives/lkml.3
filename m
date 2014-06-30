Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaF3O6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:58:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:41336 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaF3O6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:58:36 -0400
Date: Mon, 30 Jun 2014 11:58:31 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Jean Pihet <jean.pihet@linaro.org>,
        Fu Wei <fu.wei@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: crazy idea (was: Re: [PATCH] perf tool: Carve out ctype.h et al)
Message-ID: <20140630145831.GA4762@kernel.org>
References: <20140630070755.GA4766@pd.tnic>
 <CAFrcx1=ri4MO3SUn85KqRDc-OBdbRumM44-OsxbU6CckszhH=g@mail.gmail.com>
 <20140630100115.GC4766@pd.tnic>
 <20140630145031.GR27560@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630145031.GR27560@rric.localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 30, 2014 at 04:50:31PM +0200, Robert Richter escreveu:
> On 30.06.14 12:01:15, Borislav Petkov wrote:
> > Well, do you have it as a standalong program? If so, you can put it in
> > a repo somewhere and we can start hacking away and playing with it. If
> > not, we will have to copy the perf code *into* the RAS daemon first so
> > that we can have a separate source on which we all can work on.

> > Someone should be a maintainer of some sorts who merges the patches.

> > And we will continue working on the split so that once the perf tool is
> > properly separated, we can switch to it in the RAS daemon and drop the
> > copied code.

> > This is, to me at least, the best possible thing we can do right now so
> > as not to slow us all down.

> > Any other opinions?
 
> Perfectly fine with me.

Yeap, guess its the most sensible to do given how things went so far.

Please submit patches when you fix things on code copied from
tools/perf/ and generally when improving it.

- Arnaldo
