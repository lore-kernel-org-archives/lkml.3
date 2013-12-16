Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab3LPPSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:18:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:65136 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab3LPPSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:18:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,495,1384329600"; 
   d="scan'208";a="445043491"
Date: Mon, 16 Dec 2013 07:18:52 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
Message-ID: <20131216151852.GW22695@tassilo.jf.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20131211130448.GA2480@gmail.com>
 <87r49jttqr.fsf@ashishki-desk.ger.corp.intel.com>
 <20131211134724.GC3101@gmail.com>
 <87bo0ht5nj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131216143751.GA7959@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216143751.GA7959@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So we could make the old ABI a CONFIG_PERF_EVENTS_COMPAT_X86_BTS kind 
> of legacy option, turned off by default. That allows us its eventual 
> future phasing out.
> 
> It all depends on how useful the new tooling becomes: if interesting 
> things can be done with it via an obvious, powerful interface then 
> people might start using it.

The thing to keep in mind is that BTS is really really slow.

It's unlikely it'll be ever all that useful no matter how the API
looks like.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
