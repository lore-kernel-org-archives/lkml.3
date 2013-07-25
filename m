Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3GYQ3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:29:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab3GYQ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:29:51 -0400
Date: Thu, 25 Jul 2013 18:29:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: Re: [PATCH 0/8] perf: Finer grained full dynticks handling
Message-ID: <20130725162939.GX27075@twins.programming.kicks-ass.net>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <20130725095938.GI27075@twins.programming.kicks-ass.net>
 <20130725140216.GB7400@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725140216.GB7400@somewhere>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 04:02:17PM +0200, Frederic Weisbecker wrote:
> > Awesome, looks good, thanks Frederic!
> > 
> > Acked-by: Peter Zijlstra <peterz@infradead.org>
> 
> Great! What do you prefer? Do you want to take these or should I do a pull request
> to Ingo directly?

I had intended Ingo to pick these up; but then I remembered he's playing
road warrior atm. So I stuck them in my queue so as not to loose them.


