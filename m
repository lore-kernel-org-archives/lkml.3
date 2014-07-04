Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbaGDMvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:51:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:53204 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513AbaGDMvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:51:02 -0400
Date: Fri, 4 Jul 2014 09:50:55 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCHES 0/7] Add support for showing headers in the hist
 browser.
Message-ID: <20140704125055.GD11267@kernel.org>
References: <1404423780-24026-1-git-send-email-acme@kernel.org>
 <20140703214811.GC11267@kernel.org>
 <878uo94ia9.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uo94ia9.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 04, 2014 at 05:53:02PM +0900, Namhyung Kim escreveu:
> On Thu, 3 Jul 2014 18:48:11 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jul 03, 2014 at 06:42:53PM -0300, Arnaldo Carvalho de Melo escreveu:
> >> 	Namhyung, since you reviewed the previous patchkit, I'd like to know
> >> if I can keep the acked-by and perhaps a tested-by too. This should address the
> >> problems that Jiri pointed out in our private conversation.

> > Forgot to mention, it is available in this branch:

> >   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
> >   tmp.perf/ui/show_headers

> Thanks, you can keep my acks with fixing 7/7 changelog typo
> (s/true/false/).

Ok
 
> I think it might even go to the perf/urgent as the cumulative children
> patchset added a new children column which might confuse old users (like
> you ;-) ).

Unsure about that, quite a lot of patches :-)

> But I also think it needs to fix column/header alignment
> first, hmm...

Yeah, I noticed that after posting the patches, and it is even worse in
'perf top', it gets worse over time, as new symbols are added, etc. Will
take a look at that.

- Arnaldo
