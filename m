Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaHXOr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:47:59 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60549 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaHXOr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:47:58 -0400
Date: Sun, 24 Aug 2014 16:47:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Michael Ellerman <michaele@au1.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20140824144751.GB9455@gmail.com>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
 <20140824101123.GB1309@gmail.com>
 <20140824111635.GA2817@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140824111635.GA2817@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Sun, Aug 24, 2014 at 12:11:24PM +0200, Ingo Molnar escreveu:
> > * Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > > o Kernel fix to properly handle exited tasks, by returning POLLHUP values
> > >   on perf event file descriptors. Tooling changes will come next, but were
> > >   tested with this kernel fix. (Jiri Olsa)
>  
> > So the signoffs are really weird (and invalid) here:
>  
> > commit ce1d77c667e40631d6673717e65e72f72265bf10
> > Author: Jiri Olsa <jolsa@kernel.org>
> > Date:   Fri Aug 15 16:24:45 2014 -0300
>  
> >     perf top: Use set_term_quiet() instead of open coded equivalent
>  
> > ...    
> >     Cc: Jiri Olsa <jolsa@kernel.org>
> >     Cc: Namhyung Kim <namhyung@kernel.org>
> >     Cc: Paul Mackerras <paulus@samba.org>
> >     Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     Link: http://lkml.kernel.org/n/tip-h7n9te70flmaqfnj6l06ay6r@git.kernel.org
> >     [ Yanked this out of a patch containing this and some other change ]
> >     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>  
> > and in 7713886adc15 and f017bf0a8d92 - results of a rebase gone wrong?
> 
> Should be ok now, I recreated the perf-core-for-mingo signed tag, please
> let me know if there are still any problems,

Looks good now. Pulled, thanks a lot Arnaldo!

	Ingo
