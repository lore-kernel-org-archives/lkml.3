Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3AXNdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:33:33 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:33945 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3AXNd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:33:28 -0500
Date: Thu, 24 Jan 2013 14:33:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH][GIT PULL] tracing: Fix unsigned int compare of zero in
 recursion check
Message-ID: <20130124133324.GA6667@gmail.com>
References: <1359034154.21576.142.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359034154.21576.142.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I've put this on top of the patches I posted for linux-next, 
> as those were the patches that contained the bug this fixed.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: d41032a83b4683481cadff84bbf8e0eafeaba830
> 
> 
> Steven Rostedt (1):
>       tracing: Fix unsigned int compare of zero in recursion check
> 
> ----
>  kernel/trace/trace_functions.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Pulled, thanks Steve!

	Ingo
