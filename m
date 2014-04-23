Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbaDWTy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:54:27 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:59636 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757622AbaDWTyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:54:25 -0400
Date: Wed, 23 Apr 2014 14:54:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Max Krasnyansky <maxk@qti.qualcomm.com>
cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: vmstat: On demand vmstat workers V3
In-Reply-To: <5357EF4D.6080302@qti.qualcomm.com>
Message-ID: <alpine.DEB.2.10.1404231453410.16224@gentwo.org>
References: <000001417f6834f1-32b83f22-8bde-4b9e-b591-bc31329660e4-000000@email.amazonses.com> <CAOh2x==yrBdFDcObdz+La0y=jDERj=sxOBMvU-Kk6eGEvvwZQw@mail.gmail.com> <5357EF4D.6080302@qti.qualcomm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Max Krasnyansky wrote:

> The updates are done via the regular priority workqueue.

Yup so things could be fixed at that level with setting an additional
workqueue flag?

> I'm playing with isolation as well (has been more or less a background thing
> for the last 6+ years). Our threads that run on the isolated cores are SCHED_FIFO
> and therefor low prio workqueue stuff, like vmstat, doesn't get in the way.
> I do have a few patches for the workqueues to make things better for isolation.

Would you share those with us please?

