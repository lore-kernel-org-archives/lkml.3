Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3LGIWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 03:22:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56117 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab3LGIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 03:22:36 -0500
Message-ID: <1386404544.5673.88.camel@marge.simpson.net>
Subject: Re: [PATCH] Trace idle entry and exit times
From: Mike Galbraith <bitbucket@online.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, lenb@kernel.org, tglx@linutronix.de,
        peterz@infradead.org
Date: Sat, 07 Dec 2013 09:22:24 +0100
In-Reply-To: <20131207052029.GC21717@two.firstfloor.org>
References: <1386377164-2223-1-git-send-email-andi@firstfloor.org>
	 <1386392252.5673.31.camel@marge.simpson.net>
	 <20131207052029.GC21717@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:DinOpTPZ98tbWvIQaKE5oxNyx/N4qJgZiO96kuNC687
 kwGzBqfVbXUOaEEoCono43W41fNW7yJAnR6Isyr9QYI48frjHn
 lEGMzCP2PCk6yLu3wI4lJimj3fu2hpGY1YX828MlbBjKUNrt2w
 5uIqW0z/S+5GjjWZ8XMaVuCL68RFy88d3rvL7ZmSATeowi5qEs
 aNAl8vGIxnXNODvOppwXsLqAuvX3+jqO7TyycVDwNEn8YP1I3i
 y2jt2QKZVyBQ2u0vEIMdVAoTFV01lY89psA6QMkhiKOSqxb2ld
 vF7PGzM8u5/Rk+N1ACLReJWpifoKa1lMmSFN7Du9FNgTLmF9jo
 azDrzwRQR57ZzATDYk+olvJpZoR/HS+Qp/sPuOlWzZo4wrnMBE
 RLvb8o02/NnKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-07 at 06:20 +0100, Andi Kleen wrote: 
> On Sat, Dec 07, 2013 at 05:57:32AM +0100, Mike Galbraith wrote:
> > On Fri, 2013-12-06 at 16:46 -0800, Andi Kleen wrote: 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > This patch creates 4 new trace points: one at the beginning of idle,
> > > one before entering mwait, one after exiting mwait, and one after
> > > finishing the idle code. This is useful to trace down any
> > > additional latencies caused by the ever-growing idle code.
> > > 
> > > Idle latencies are a common source of performance problems, so it's
> > > important to be able to measure them.
> > 
> > You mean stuff like.. oh, say 60 cores doing zero work every 12ms
> > munching ~20% cpu?
> 
> Well that one is obvious. I mean more the subtle problems.

Yeah, not subtle.  SGI could use C2 as power supply stress tester.

-Mike

