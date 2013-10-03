Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3JCI6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:58:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40278 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3JCI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:58:19 -0400
Date: Thu, 3 Oct 2013 10:58:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [BUG] perf tests: Test converting perf time to TSC
Message-ID: <20131003085807.GO26785@twins.programming.kicks-ass.net>
References: <20131002132308.GB20396@krava.brq.redhat.com>
 <524C23D3.6020300@intel.com>
 <20131003081737.GB993@krava.brq.redhat.com>
 <524D2E06.5020801@intel.com>
 <20131003085625.GA3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003085625.GA3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 10:56:25AM +0200, Peter Zijlstra wrote:
> > No the ABI is broken in that case - better to crash.
> 
> No; neither case should crash.

OK; previously we would report cap_usr_time = 1 even though we might not
have written stuff into the fields; which would indeed explain the
crash.

However; Jiri actually has the patch; as the code he posted had 'user' not
'usr'
