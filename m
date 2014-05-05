Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaEENtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:49:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:55532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbaEENtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:49:45 -0400
Date: Mon, 5 May 2014 10:49:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/10] perf tools: perf.h cleanups
Message-ID: <20140505134934.GA3006@kernel.org>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 05, 2014 at 02:33:29PM +0200, Jiri Olsa escreveu:
> hi,
> moving syscall function and arch related defines into
> new header 'perf-sys.h' as requested by Peter in:
>   http://lkml.kernel.org/r/20140502115201.GI30445@twins.programming.kicks-ass.net
> 
> While at it I did some clean ups in perf.h header.
> 
> Hopefully I did not brake anyone's usage of
> perf.h .. let me know ;-)
> 
> Also available in here:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/header_1

With that ACCESS_ONCE comments made addressed:

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
