Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3GYOCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:02:24 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47726 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab3GYOCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:02:21 -0400
Date: Thu, 25 Jul 2013 16:02:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: Re: [PATCH 0/8] perf: Finer grained full dynticks handling
Message-ID: <20130725140216.GB7400@somewhere>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <20130725095938.GI27075@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725095938.GI27075@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:59:38AM +0200, Peter Zijlstra wrote:
> On Tue, Jul 23, 2013 at 02:30:58AM +0200, Frederic Weisbecker wrote:
> > Hi,
> > 
> > This patchset inspires from Peterz patch in http://marc.info/?l=linux-kernel&m=137155182121860
> > to make perf retain the timer tick less often, ie: only when there are freq events
> > or when one throttles.
> > 
> > The main purpose is to make the lockup detector work with full dynticks, as I suspect
> > that distros want to enable both...
> > 
> > 
> > You can fetch from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	perf/nohz
> > 
> > Thanks,
> > 	Frederic
> 
> Awesome, looks good, thanks Frederic!
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>

Great! What do you prefer? Do you want to take these or should I do a pull request
to Ingo directly?

Thanks!
