Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3GYJ7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:59:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34002 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3GYJ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:59:50 -0400
Date: Thu, 25 Jul 2013 11:59:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: Re: [PATCH 0/8] perf: Finer grained full dynticks handling
Message-ID: <20130725095938.GI27075@twins.programming.kicks-ass.net>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 02:30:58AM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> This patchset inspires from Peterz patch in http://marc.info/?l=linux-kernel&m=137155182121860
> to make perf retain the timer tick less often, ie: only when there are freq events
> or when one throttles.
> 
> The main purpose is to make the lockup detector work with full dynticks, as I suspect
> that distros want to enable both...
> 
> 
> You can fetch from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	perf/nohz
> 
> Thanks,
> 	Frederic

Awesome, looks good, thanks Frederic!

Acked-by: Peter Zijlstra <peterz@infradead.org>
