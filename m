Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaFFIFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:05:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:56252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaFFIFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:05:50 -0400
Date: Fri, 6 Jun 2014 10:05:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140606080543.GR6758@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <20140604160230.GS29593@e103034-lin>
 <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
 <2484761.vkWavnsDx3@vostro.rjw.lan>
 <20140605065205.GA3213@twins.programming.kicks-ass.net>
 <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JKGvNdIvrY8Ovf7Z"
Content-Disposition: inline
In-Reply-To: <20140605202930.GA15484@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JKGvNdIvrY8Ovf7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2014 at 04:29:30AM +0800, Yuyang Du wrote:
> On Thu, Jun 05, 2014 at 08:03:15AM -0700, Dirk Brandewie wrote:
> >=20
> > You can request a P state per core but the package does coordination at
> > a package level for the P state that will be used based on all requests.
> > This is due to the fact that most SKUs have a single VR and PLL. So
> > the highest P state wins.  When a core goes idle it loses it's vote
> > for the current package P state and that cores clock it turned off.
> >=20
>=20
> You need to differentiate Turbo and non-Turbo. The highest P state wins? =
Not
> really.

*sigh* and here we go again.. someone please, write something coherent
and have all intel people sign off on it and stop saying different
things.

> Actually, silicon supports indepdent non-Turbo pstate, but just not enabl=
ed.

Then it doesn't exist, so no point in mentioning it.

> For Turbo, it basically depends on power budget of both core and gfx (bec=
ause
> they share) for each core to get which Turbo point.

And RAPL controls can give preference of which gfx/core gets most,
right?

> > intel_pstate tries to keep the core P state as low as possible to satis=
fy
> > the given load, so when various cores go idle the package P state can be
> > as low as possible.  The big power win is a core going idle.
> >=20
>=20
> In terms of prediction, it is definitely can't be 100% right. But the
> performance of most workloads does scale with pstate (frequency), may not=
 be
> linearly. So it is to some point predictable FWIW. And this is all govern=
ors
> and Intel_pstate's basic assumption.

So frequency isn't _that_ interesting, voltage is. And while
predictability it might be their assumption, is it actually true? I
mean, there's really nothing else except to assume that, if its not you
can't do anything at all, so you _have_ to assume this.

But again, is the assumption true? Or just happy thoughts in an attempt
to do something.

--JKGvNdIvrY8Ovf7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkXZXAAoJEHZH4aRLwOS6Rr0QALHzVn13dqJC5ID0gp82Koqr
Z2ICa/DvF9U9fAVTRMasiU0M8QubtwEXU0hk24inAn+wimMN9MXcCUgdCuZ3Dd6K
eoOpH2mY4JtBH0zu7yuKF181PqSZHdPayBccToMzEAKBqvkAUe+pTFjf+mjrW6Pg
/9q4M5r4A/CKEArgPKKGigxpDFSyr+1gHlrvL9zYJoRsByoxNrjH16sOTPK1D4K9
pqPmkefxas8XwP9s5jR4ifNzdndsDce7cIFkpJVKOXMt84XRw1Q+iCRe0gMw1j4w
fq73KlasoFbznmGpAcGYjxPMc+9wBnGXN4mATzheJZn83Poh9bW4YqzmUYFR2F5S
ErBJCWNL4/Z0GIZNI7DLVH2jFwuIu/PYRtqq2xkUb47Xag6NR6DrcSvxB6y7/A0u
lmw2cQ0m0CvcH8+hcfEvlReCHc82rbM3X2Xkadnj5EGHPWrpDYzsdGki/U6BdLwZ
4dn6rwHj0F/KXeXuD2tnGjeAPUIoqqfDAsGibOeGV25D6dYNHhqpdcz3WsXoVVsL
6kxxCm1MOnfUhW73lGc+wC4Eo9KLivqEZ2+KgPAy0Q6vHEOyKJw4/Tm+sXxtiFrm
6qT2Y5HpcMF0kxg9Gl5TEEtXzpbLaXJmologk5y37/DEQ3XxEnlJXZqDI6+bdyn0
jLZijbdI5wZwHMhXMx1R
=wowj
-----END PGP SIGNATURE-----

--JKGvNdIvrY8Ovf7Z--
