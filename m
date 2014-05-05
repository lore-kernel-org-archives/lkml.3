Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaEEMq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:46:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbaEEMqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:46:24 -0400
Date: Mon, 5 May 2014 14:46:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 00/10] perf tools: perf.h cleanups
Message-ID: <20140505124620.GO26782@laptop.programming.kicks-ass.net>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 02:33:29PM +0200, Jiri Olsa wrote:
> hi,
> moving syscall function and arch related defines into
> new header 'perf-sys.h' as requested by Peter in:
>   http://lkml.kernel.org/r/20140502115201.GI30445@twins.programming.kicks-ass.net
> 
> While at it I did some clean ups in perf.h header.
> 
> Hopefully I did not brake anyone's usage of
> perf.h .. let me know ;-)

break, brake is to slow down, also possibly appropriate ;-)

Thanks!

Acked-by: Peter Zijlstra <peterz@infradead.org>
