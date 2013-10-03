Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3JCIR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab3JCIRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:17:54 -0400
Date: Thu, 3 Oct 2013 10:17:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [BUG] perf tests: Test converting perf time to TSC
Message-ID: <20131003081737.GB993@krava.brq.redhat.com>
References: <20131002132308.GB20396@krava.brq.redhat.com>
 <524C23D3.6020300@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524C23D3.6020300@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:46:59PM +0300, Adrian Hunter wrote:
> On 02/10/13 16:23, Jiri Olsa wrote:
> > hi,
> > got a segfault in the tsc test on latest acme's tree.
> > 
> > I'm dealing with some other issues right now, so just reporting ;-)
> 
> The capability bits have changed positions.  You need to have:
> 
> commit fa7315871046b9a4c48627905691dbde57e51033
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Thu Sep 19 10:16:42 2013 +0200
> 
>     perf: Fix capabilities bitfield compatibility in 'struct
> perf_event_mmap_page'

ok, I'll try that.. but anyway, the test should
not crash in account of missing kernel change 

jirka
