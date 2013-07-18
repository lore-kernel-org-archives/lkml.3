Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab3GRMw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab3GRMwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:52:54 -0400
Date: Thu, 18 Jul 2013 14:52:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/23] perf tests: Add simple session read/write test
Message-ID: <20130718125231.GE1092@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-6-git-send-email-jolsa@redhat.com>
 <87fvvcwbt0.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvvcwbt0.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 04:46:03PM +0900, Namhyung Kim wrote:
> On Wed, 17 Jul 2013 19:49:45 +0200, Jiri Olsa wrote:
> > Adding simple session read/write test to keep up
> > with file format changes.
> >
> [SNIP]
> 
> > +	session = perf_session__new(file, O_RDONLY, false, false, &tool);
> > +	TEST_ASSERT_VAL("failed to create session", session);
> > +
> > +	TEST_ASSERT_VAL("failed to process events", session);
> > +		perf_session__process_events(session, &tool);
> 
> Did you mean
> 
> 	TEST_ASSERT_VAL("failed to process events",
> 		perf_session__process_events(session, &tool));
> ?

ouch, yes I did ;-)

thanks,
jirka
