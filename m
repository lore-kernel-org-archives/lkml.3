Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaKKSBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:01:05 -0500
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:42312 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbaKKSBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:01:03 -0500
Date: Tue, 11 Nov 2014 12:00:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: Future of NOHZ full/isolation development (was Re: [NOHZ] Remove
 scheduler_tick_max_deferment)
In-Reply-To: <20141111173908.GY4901@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1411111159490.6018@gentwo.org>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org> <alpine.DEB.2.11.1411012003390.5308@nanos> <alpine.DEB.2.11.1411011646280.7732@gentwo.org> <alpine.DEB.2.11.1411012313320.5308@nanos> <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
 <CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com> <20141110153147.GK4901@linux.vnet.ibm.com> <alpine.DEB.2.11.1411101226310.12918@gentwo.org> <20141111171526.GC3216@lerouge> <20141111173908.GY4901@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Paul E. McKenney wrote:

> I guess I should have remembered that before suggesting this to Christoph,
> my apologies to all!

No this is good. Do not worry. I can just throw out the one or other patch
to ensure that the discussion continues and then we can figure out how to
come up with a correct solution. Patches are a way to say that you are
serious about an issue on lkml.

