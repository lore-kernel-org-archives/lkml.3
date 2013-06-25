Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab3FYPSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:18:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:31518 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab3FYPSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:18:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,937,1363158000"; 
   d="scan'208";a="335289893"
Date: Tue, 25 Jun 2013 08:18:26 -0700
From: Andi Kleen <ak@linux.jf.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf tools: Introduce new -P/--parent-deep report
 option
Message-ID: <20130625151826.GQ5643@tassilo.jf.intel.com>
References: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
 <1372161253-22081-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372161253-22081-5-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 01:54:12PM +0200, Jiri Olsa wrote:
> Introducing new -P/--parent-deep report option. It does the
> same as '-p' but it force the deep search of the callchain
> and looks for the deepest possible match.

This doesn't make sense to me as an option.

If it's a more correct callgraph it should be default, not 
an option.

A option like "give me correct data" doesn't make sense.

-Andi
