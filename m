Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaBCQkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:40:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaBCQka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:40:30 -0500
Date: Mon, 3 Feb 2014 17:39:46 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 3/3] perf tools: Add readable output for callchain debug
Message-ID: <20140203163946.GB1129@krava.brq.redhat.com>
References: <1391427883-13443-1-git-send-email-jolsa@redhat.com>
 <1391427883-13443-3-git-send-email-jolsa@redhat.com>
 <20140203150915.GA2352@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203150915.GA2352@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 01:09:15PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Feb 03, 2014 at 12:44:43PM +0100, Jiri Olsa escreveu:
> > Adding people readable output for callchain debug,
> > to get following '-v' output:
> > 
> >   $ perf record -v -g ls
> >   callchain: type DWARF
> >   callchain: stack dump size 4096
> >   ...
> 
> Applied, but then I tried:
> 
> [acme@zoo linux]$ perf evlist -v
> cycles: sample_freq=4000, size: 96, sample_type:
> IP|TID|TIME|CALLCHAIN|PERIOD, disabled: 1, inherit: 1, mmap: 1, comm: 1,
> freq: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
> [acme@zoo linux]$ 
> 
> 
> I.e. using the tool that provides info about 'perf.data' files, and
> there I couldn't figure it out which kind of callchains was used, can
> you fix it there too?

todo updated ;-)

jirka
