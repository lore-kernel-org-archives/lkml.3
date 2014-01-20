Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaATLaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:30:24 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65102 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaATLaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:30:20 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<20140115171704.GB21574@localhost.localdomain>
	<CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
	<alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
Date: Mon, 20 Jan 2014 17:00:20 +0530
Message-ID: <CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 January 2014 15:16, Thomas Gleixner <tglx@linutronix.de> wrote:
> Just do the math.
>
>      max reload value / timer freq = max time span

Thanks.

> So:
>
>      0x7fffffff / 24MHz = 89.478485 sec
>
> Nothing to do here except to get rid of the requirement to arm the
> timer at all.

@Frederic: Any inputs on how to get rid of this timer here?
