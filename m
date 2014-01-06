Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaAFQ15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:27:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:52633 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbaAFQ14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:27:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,613,1384329600"; 
   d="scan'208";a="434558559"
Date: Mon, 6 Jan 2014 08:27:54 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf tools: enable close-on-exec flag on perf file
 descriptor
Message-ID: <20140106162754.GE27909@tassilo.jf.intel.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
 <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
 <20140106092929.GA31570@twins.programming.kicks-ass.net>
 <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 11:51:25AM +0100, Yann Droneaud wrote:
> In a previous patch [1][2], flag PERF_FLAG_FD_CLOEXEC was
> added to perf_event_open(2) syscall to allows userspace
> to enable close-on-exec behavor atomically when creating
> the file descriptor.
> 
> This patch makes perf tools use the new flag.

What is that good for? I can see why for a threaded program, but 
"perf" is not threaded.

-Andi
