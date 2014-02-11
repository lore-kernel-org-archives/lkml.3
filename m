Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaBKIwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:52:45 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:65230 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:52:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140128132306.GB9172@localhost.localdomain>
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
Date: Tue, 11 Feb 2014 14:22:43 +0530
Message-ID: <CAKohpommw4=LcyYKvj8rNJgUkOT+_Gh=1kppcDQYm3BuQQe_Qg@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2014 18:53, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> No, when a single task is running on a full dynticks CPU, the tick is supposed to run
> every seconds. I'm actually suprised it doesn't happen in your traces, did you tweak
> something specific?

Why do we need this 1 second tick currently? And what will happen if I
hotunplug that
CPU and get it back? Would the timer for tick move away from CPU in
question? I see
that when I have changed this 1sec stuff to 300 seconds. But what
would be impact
of that? Will things still work normally?
