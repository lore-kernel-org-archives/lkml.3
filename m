Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3JKNE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:04:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37548 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3JKNE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:04:56 -0400
Date: Fri, 11 Oct 2013 15:04:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
Message-ID: <20131011130441.GC28601@twins.programming.kicks-ass.net>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131011055829.GA4975@gmail.com>
 <20131011073448.GA11064@krava.redhat.com>
 <8761t4cizo.fsf@sejong.aot.lge.com>
 <20131011125935.GA10634@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011125935.GA10634@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:59:35PM +0200, Ingo Molnar wrote:
> So, why not keep -g as a shortcut to whatever default call-graph profiling 
> we want to provide (note, this does not mean it always has to be 'fp'), 
> and use --call-graph for more specific variants?
> 
> a .perfconfig value could even set the default for '-g', so that you don't 
> have to type '--call-graph dwarf' all the time.


Another, slightly related annoyance I have is with -B, we default to
--big-num so -B is utterly useless, and the only remaining option is
--no-big-num.

