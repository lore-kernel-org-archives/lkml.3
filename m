Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaBCI0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:26:19 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:48785 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaBCI0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:26:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAGa+x86JwUOn6DG+T7VrGy4CqG3-6NCxNcB3mZfD0VBNXBk6_w@mail.gmail.com>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<20140115171704.GB21574@localhost.localdomain>
	<CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
	<alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
	<CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
	<20140120155145.GB9436@localhost.localdomain>
	<CAKohpom8av7A1wwcdOr5+LpHz--P+s9m_gR_9B+Aa4fpwkN7uQ@mail.gmail.com>
	<20140123145842.GD13345@localhost.localdomain>
	<CAKohpok5AObcFbOmLYGT-KkjhVHUiLRZ=AYqofYk59_sVneSjA@mail.gmail.com>
	<20140128132306.GB9172@localhost.localdomain>
	<CAGa+x86JwUOn6DG+T7VrGy4CqG3-6NCxNcB3mZfD0VBNXBk6_w@mail.gmail.com>
Date: Mon, 3 Feb 2014 13:56:17 +0530
Message-ID: <CAKohpomeeewxZ2oAeietWe49Z2SARiG0FNjHFz+gfBzNq_RdwQ@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2014 21:41, Kevin Hilman <khilman@linaro.org> wrote:
> I think Viresh is using my patch/hack to configure/disable the 1Hz
> residual tick.

Yeah. I am using sched_tick_max_deferment by setting it to -1. Why
do we need a timer every second for NO_HZ_FULL currently?
