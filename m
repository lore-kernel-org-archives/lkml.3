Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbaEENOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:14:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbaEENO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:14:29 -0400
Date: Mon, 5 May 2014 15:13:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 10/10] perf tools: Move ACCESS_ONCE from perf.h header
Message-ID: <20140505131356.GA1274@krava.brq.redhat.com>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
 <1399293219-8732-11-git-send-email-jolsa@kernel.org>
 <20140505124536.GN26782@laptop.programming.kicks-ass.net>
 <20140505125922.GD5667@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505125922.GD5667@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 02:59:22PM +0200, Borislav Petkov wrote:
> On Mon, May 05, 2014 at 02:45:36PM +0200, Peter Zijlstra wrote:
> > One could argue its part of the barrier muck, but sure.
> 
> Yeah, it might be prudent to put stuff like that in the most fitting
> headers from the get-go as it causes trouble otherwise. And for
> ACCESS_ONCE, in particular, we have tools/include/linux/compiler.h which
> is a subset of include/linux/compiler.h so maybe it should go there.

right, that sounds like better place, I'll put it there

thanks,
jirka
