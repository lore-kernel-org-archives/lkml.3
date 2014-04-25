Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaDYSnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:43:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaDYSnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:43:40 -0400
Date: Fri, 25 Apr 2014 20:43:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Amit Kucheria <amit.kucheria@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Message-ID: <20140425184327.GH26782@laptop.programming.kicks-ass.net>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
 <535911DC.9050109@linaro.org>
 <CAP245DXFRfARtEfj70XD8D8OiAT_1i_5G2zao+y0DT0Lg_YFJA@mail.gmail.com>
 <2713863.BLQTYQm2Oa@vostro.rjw.lan>
 <20140425132055.GC11096@twins.programming.kicks-ass.net>
 <535A94E3.5080004@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A94E3.5080004@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 07:01:23PM +0200, Daniel Lezcano wrote:
> As the sysctl is some kind of ABI, I would like to make sure we reach a
> consensus and discuss a bit about that.

We could make it a sysfs file, like /sys/power/state, which when read
provides the words it takes.

That is more flexible than a numeric sysctl for which we have to keep an
enumeration.
