Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaIBKul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:50:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:33175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaIBKuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:50:40 -0400
Date: Tue, 2 Sep 2014 12:50:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/9] perf: Remove redundant parent context check from
 context_equiv
Message-ID: <20140902105036.GH5806@worktop.ger.corp.intel.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408977943-16594-2-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 04:45:35PM +0200, Jiri Olsa wrote:
> As described in commit:
>   1f9a7268c67f perf: Do not allow optimized switch for non-cloned events
> we dont allow optimized switch for non cloned contexts.
> 
> There's no need now to check if one of the context is parent
> of the other in context_equiv function.
> 

OK, so talk to me about that patch; it looks like you're slowly
reverting: 5a3126d4fe7c ("perf: Fix the perf context switch
optimization").

So what exactly is the problem? I'm still jet-lagged and not seeing it.
