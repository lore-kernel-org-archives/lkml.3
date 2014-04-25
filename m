Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaDYNWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:22:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaDYNWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:22:45 -0400
Date: Fri, 25 Apr 2014 15:22:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Message-ID: <20140425132238.GD11096@twins.programming.kicks-ass.net>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
 <1398342291-16322-3-git-send-email-daniel.lezcano@linaro.org>
 <CAP245DX9wewQFhcyGj5ZuNE7hHC4fRn90POC32HLF6ugja6nJg@mail.gmail.com>
 <535911DC.9050109@linaro.org>
 <CAP245DXFRfARtEfj70XD8D8OiAT_1i_5G2zao+y0DT0Lg_YFJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP245DXFRfARtEfj70XD8D8OiAT_1i_5G2zao+y0DT0Lg_YFJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The infinite wisdom of the original PC keyboard gifted us with backspace
and delete, use them!

On Fri, Apr 25, 2014 at 04:24:49PM +0530, Amit Kucheria wrote:
> In that case, "performance" should be the default so we don't change
> existing system behavior. And perhaps we want to keep these energy
> heuristics in a separate file, at least until we've gotten them right.

No, we're not going to make a separate file. Its going to be fully
integrated in the normal load balancer, no special add on hacks and
warts.
