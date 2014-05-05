Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaEEN7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:59:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbaEEN7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:59:51 -0400
Date: Mon, 5 May 2014 15:59:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/10] perf tools: perf.h cleanups
Message-ID: <20140505135937.GB1274@krava.brq.redhat.com>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
 <20140505134934.GA3006@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505134934.GA3006@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 10:49:34AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, May 05, 2014 at 02:33:29PM +0200, Jiri Olsa escreveu:
> > hi,
> > moving syscall function and arch related defines into
> > new header 'perf-sys.h' as requested by Peter in:
> >   http://lkml.kernel.org/r/20140502115201.GI30445@twins.programming.kicks-ass.net
> > 
> > While at it I did some clean ups in perf.h header.
> > 
> > Hopefully I did not brake anyone's usage of
> > perf.h .. let me know ;-)
> > 
> > Also available in here:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   perf/header_1
> 
> With that ACCESS_ONCE comments made addressed:
> 
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>


eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeey ;-)

welcome back!!!

jirka
