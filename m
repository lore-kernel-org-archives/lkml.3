Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbaFLMwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:52:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50815 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbaFLMwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:52:41 -0400
Date: Thu, 12 Jun 2014 14:49:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] tools:perf: move tools/perf/util to tools/lib/perf_util
Message-ID: <20140612124918.GC4857@pd.tnic>
References: <1402561602-28807-1-git-send-email-jean.pihet@linaro.org>
 <20140612123432.GA2608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140612123432.GA2608@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 09:34:32AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jun 12, 2014 at 10:26:42AM +0200, Jean Pihet escreveu:
> > This is a first move of the perf code into a set of libraries, which
> > allow the implementation of other external tools.
> > 
> > The first users of the perf libraries would be:
> > - perf itself,
> > - the RAS daemon.
> > 
> > The commit includes:
> > - the move of the code from util to lib/perf_util,
> > - creation of Makefile in perf_util,
> > - update of Makefile.perf to build a library for perf_util,
> > - fix of the include paths, eg. "../perf.h" to <perf.h>, "util/hist.h" to
> >   <hist.h>
> 
> Can't you just go moving what you actually use? Or do you really plan to
> use all that?

You asked me that same question when I was doing that. :-)

And I told Jean repeatedly that this needs to be splitted slowly, in
smaller libraries like we've been discussing it numerous times.

:-\

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
