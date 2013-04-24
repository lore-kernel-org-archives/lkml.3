Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab3DXGuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:50:24 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:35716 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3DXGuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:50:22 -0400
Date: Wed, 24 Apr 2013 08:50:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf tools: Introduce new 'ftrace' command
Message-ID: <20130424065018.GC27551@gmail.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366732681.9609.157.camel@gandalf.local.home>
 <CAOJsxLF16Edznsdis4NK-O1Sf=3Eswb5L=cfBDhjpr6F7UjTbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLF16Edznsdis4NK-O1Sf=3Eswb5L=cfBDhjpr6F7UjTbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> Hello,
> 
> On Tue, 2013-04-23 at 17:30 +0900, Namhyung Kim wrote:
> >> This patchset implements a front-end tool for kernel's ftrace.  It
> >> uses function_graph tracer by default and normal function tracer is
> >> also supported.  (Of course you need to enable those tracers in your
> >> kernel first.)
> 
> On Tue, Apr 23, 2013 at 6:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Very nice Namhyung, thanks for doing this. I did a quick run through of
> > the patches and I have no complaints about them. I'm not sure how the
> > others will feel about it.
> 
> I also skimmed through the patches and they look like a reasonable
> starting point. So FWIW,
> 
> Acked-by: Pekka Enberg <penberg@kernel.org>
> 
> Are there any plans in trying to consolidate 'perf trace' and this? As
> a user I don't really care what the underlying mechanism and would
> like things to just work out of the box.

Exactly. I'd love to see ftrace and perf trace unified.

I have no objections against having a 'perf ftrace' interim step - as long 
as it's really a temporary migration construct, not something we intend to 
keep forever.

Thanks,

	Ingo
