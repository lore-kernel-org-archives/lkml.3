Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaDVNip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:38:45 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:33932 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbaDVNim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:38:42 -0400
Date: Tue, 22 Apr 2014 08:38:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: vmstat: On demand vmstat workers V3
In-Reply-To: <CAOh2x==yrBdFDcObdz+La0y=jDERj=sxOBMvU-Kk6eGEvvwZQw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1404220838090.4299@gentwo.org>
References: <000001417f6834f1-32b83f22-8bde-4b9e-b591-bc31329660e4-000000@email.amazonses.com> <CAOh2x==yrBdFDcObdz+La0y=jDERj=sxOBMvU-Kk6eGEvvwZQw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Viresh Kumar wrote:

> On Thu, Oct 3, 2013 at 11:10 PM, Christoph Lameter <cl@linux.com> wrote:
> > V2->V3:
> > - Introduce a new tick_get_housekeeping_cpu() function. Not sure
> >   if that is exactly what we want but it is a start. Thomas?
> > - Migrate the shepherd task if the output of
> >   tick_get_housekeeping_cpu() changes.
> > - Fixes recommended by Andrew.
>
> This vmstat interrupt is disturbing my core isolation :), have you got
> any far with this patchset?

Sorry no too much other stuff. Would be glad if you could improve on it.
Should have some time on Friday to look at it.

