Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3FYPfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3FYPfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:35:19 -0400
Date: Tue, 25 Jun 2013 17:34:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <ak@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf tools: Introduce new -P/--parent-deep report
 option
Message-ID: <20130625153417.GM23329@krava.brq.redhat.com>
References: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
 <1372161253-22081-5-git-send-email-jolsa@redhat.com>
 <20130625151826.GQ5643@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625151826.GQ5643@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 08:18:26AM -0700, Andi Kleen wrote:
> On Tue, Jun 25, 2013 at 01:54:12PM +0200, Jiri Olsa wrote:
> > Introducing new -P/--parent-deep report option. It does the
> > same as '-p' but it force the deep search of the callchain
> > and looks for the deepest possible match.
> 
> This doesn't make sense to me as an option.
> 
> If it's a more correct callgraph it should be default, not 
> an option.
> 
> A option like "give me correct data" doesn't make sense.

I thought the '-p' behaviour was for a reason not a bug,
but I can change it to do the deep search and dont add '-P'

jirka
