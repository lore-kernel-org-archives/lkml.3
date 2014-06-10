Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaFJMYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:24:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:49195 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaFJMYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:24:40 -0400
Date: Tue, 10 Jun 2014 14:24:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Henrik Austad <henrik@austad.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 02/16] sched: Introduce CONFIG_SCHED_ENERGY
Message-ID: <20140610122435.GG6758@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
 <20140608060316.GA18179@austad.us>
 <20140609102027.GA29593@e103034-lin>
 <20140610093943.GA6758@twins.programming.kicks-ass.net>
 <20140610100641.GB1581@e103034-lin>
 <20140610102353.GC6758@twins.programming.kicks-ass.net>
 <20140610112403.GC1581@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gJgGjUUWrnN4mpen"
Content-Disposition: inline
In-Reply-To: <20140610112403.GC1581@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gJgGjUUWrnN4mpen
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 12:24:03PM +0100, Morten Rasmussen wrote:
> On Tue, Jun 10, 2014 at 11:23:53AM +0100, Peter Zijlstra wrote:
> > On Tue, Jun 10, 2014 at 11:06:41AM +0100, Morten Rasmussen wrote:
> > > How would you like to disable the energy stuff for users for whom
> > > latency is everything?
> > >=20
> > > I mean, we are adding some extra load/utilization tracking. While I
> > > think we should do everything possible to minimize the overhead, I th=
ink
> > > it is unrealistic to assume that it will be zero. Is a some extra 'if
> > > (energy_enabled)' acceptable?
> > >=20
> > > I'm open for other suggestions.
> >=20
> > We have the jump-label stuff to do self modifying code ;-) The only
> > thing we need to be careful with is data-layout.
>=20
> Thanks. I can see that it is already used in for various bit in
> kernel/sched/*. I didn't catch anything in Documentation/static-keys.txt
> related to data-layout caveats. Is there some other
> documentation/patches I should read before messing everything up? ;-)

So the data-layout was mostly referring to things like making sure that
struct sched_avg doesn't end up straddling a cacheline somewhere by
accident.

The most expensive part of the per-task accounting nonsense is the
amount of memory we need to touch to do so, the actual instructions come
second, unless of course we go put tons of divisions in there :-)

BTW, are cachelines 64 bytes for you ARM people too?


--gJgGjUUWrnN4mpen
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlvkDAAoJEHZH4aRLwOS65qQP/RkQjZTvnviSG5PwG4lCiBgk
W53tNIdEKmkqpX/Nv0jomq0JGrd+GaVifrj1iNxXJVZ7ZnLR8lGdJvbL59Kxesl2
5mW6SyWXHil4M8ILHRDTWqtMsQVo6oMNTUYj+TfU6h1rsNk7kZDNL0tVTH/jsXTX
uK6Q/zUz4BH3R+ohxOULbl15J+/YUFgVKi8e3R+07vHrh8M1ig+eBh4FtTZpBjVT
J1Jgh3OxOraz3RQh1g0EC6vg04lw1QDOCMvy5DGGR8ZXYOsVEekDznzSosbLO19e
j0aqMt2VPwZBqQKrj+xsg160cWbUPK+3pjIBRi5ZAu5wvpqJW7vZL3cXFgundU8d
bFLFWh20aw0hOep2MTeVjbt8wlcJOUgyct7lFm4GP75iHWT6hB9AxaFEH+yjfrPP
nzTnKH558n31Xgg8uHOvaQCjDZ0L+vmypuVP3CKVYaTBwpHLiWyKfJM9/OkW+kd8
rM8sxDJW/BB62c1cFaV1gee7wFbYYVBWSwitA0FnSfgiRn2XBJgCNJ1DV6/5yKw5
f6ifI3js93grHRkEWU3T04RFlMTKtoD1ABl2Y1MVAj+sr9oiqSdHi5l4iuZYkRbI
IB+QBZqNMx+P9yptZC9MU2Uuxh/cYpRtYTdQ4sCg2pkNRb8fcHiRWAR+GLmK4Sp7
vt4GOOBI02Kt/8WjAzbH
=YZNU
-----END PGP SIGNATURE-----

--gJgGjUUWrnN4mpen--
