Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbaFLKuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:50:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:39437 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbaFLKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:50:11 -0400
Date: Thu, 12 Jun 2014 12:49:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Julia.Lawall@lip6.fr
cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        John Stultz <john.stultz@linaro.org>, cocci@systeme.lip6.fr,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Cocci] [patch 04/13] net: mac80211: Use ktime_get_ts()
In-Reply-To: <20140612115134.205432hq8ztc6pt2@webmail.lip6.fr>
Message-ID: <alpine.DEB.2.10.1406121236140.5170@nanos>
References: <20140611234024.103571777@linutronix.de> <20140611234607.020125642@linutronix.de> <1402556024.4224.2.camel@jlt4.sipsolutions.net> <CAB=NE6UqxX=K2iZhHQBmMU4wTBmAmj7KbnJBktepB8+JJn0LDQ@mail.gmail.com>
 <20140612115134.205432hq8ztc6pt2@webmail.lip6.fr>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-620757281-1402570176=:5170"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-620757281-1402570176=:5170
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 12 Jun 2014, Julia.Lawall@lip6.fr wrote:

> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> a écrit :
> 
> > On Wed, Jun 11, 2014 at 11:53 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > On Wed, 2014-06-11 at 23:59 +0000, Thomas Gleixner wrote:
> > > 
> > > > do_posix_clock_monotonic_gettime() is a leftover from the initial
> > > > posix timer implementation which maps to ktime_get_ts().
> > > 
> > > I didn't even know we *had* such code, heh.
> > 
> > If we want want maintainers to police this stuff we can add an SmPL
> > rule for this upstream and have maintainer use 'make coccicheck
> > M=path/'. The way of the future. The way of the future...
> 
> If I could have a little more context, I can do something.

I already killed all instances of do_posix_clock_monotonic_gettime().
The define will be gone soon, so nothing to worry about.

Thanks,

	tglx
--8323329-620757281-1402570176=:5170--
