Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3ICNiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:38:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33718 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3ICNiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:38:04 -0400
Date: Tue, 3 Sep 2013 10:37:48 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [GIT PULL] perf changes for v3.12
Message-ID: <20130903133748.GE9064@ghostprotocols.net>
References: <20130903132933.GA24955@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903132933.GA24955@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 03, 2013 at 03:29:33PM +0200, Ingo Molnar escreveu:
> Linus,
> 
> Please pull the latest perf-core-for-linus git tree from:

There were some misatributions I found, from memory, here, clarifying
FWIW:
 
>    * 'perf test' enhancements:
> 
>         . Add various improvements and fixes to the "vmlinux matches 
>           kallsyms" 'perf test' entry, related to the /proc/kcore 
>           annotation feature. By Arnaldo Carvalho de Melo.

by Adrian Hunter
     
>    * 'perf sched' enhancements:
>     
>         . Various improvements, including removing reliance on some 
>           scheduler tracepoints that provide the same information as the 
>           PERF_RECORD_{FORK,EXIT} events. By Arnaldo Carvalho de Melo.

By David Ahern.
 
:-)

- Arnaldo
