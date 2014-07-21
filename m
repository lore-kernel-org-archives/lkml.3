Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584AbaGUTj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 15:39:27 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46436 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbaGUTj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 15:39:26 -0400
Date: Mon, 21 Jul 2014 21:39:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
Message-ID: <20140721193921.GO18735@two.firstfloor.org>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <53CCB6AE.6020505@intel.com>
 <20140721080219.GA4183@krava.redhat.com>
 <53CCD3A7.5070002@intel.com>
 <20140721095415.GB8865@krava.redhat.com>
 <87d2cy3c7m.fsf@tassilo.jf.intel.com>
 <53CD5AB5.3000307@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CD5AB5.3000307@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 09:23:49PM +0300, Adrian Hunter wrote:
> On 21/07/2014 7:31 p.m., Andi Kleen wrote:
> >Jiri Olsa <jolsa@redhat.com> writes:
> >>
> >>[jolsa@ibm-x3650m4-01 perf]$ sudo ./perf report --stdio
> >>Timestamp below last timeslice flush
> >>0x2276f58 [0x68]: failed to process type: 9
> >
> >FWIW we're seeing this frequently too.
> 
> Jiri's example didn't work for me.  Do you have one?

Did you try it on a idle system? Do it during some work load
that generates a lot of context switches.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
