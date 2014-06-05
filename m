Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaFEGwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 02:52:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaFEGwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 02:52:16 -0400
Date: Thu, 5 Jun 2014 08:52:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140605065205.GA3213@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <20140604160230.GS29593@e103034-lin>
 <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
 <2484761.vkWavnsDx3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <2484761.vkWavnsDx3@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 11:56:55PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, June 04, 2014 07:27:12 PM Peter Zijlstra wrote:

> > Well, we eventually want to go there I think. Although we still needed
> > to come up with something for Intel, because I'm not at all sure how all
> > that works.
>=20
> Do you mean power numbers or how P-states work on Intel in general?

P-states, I'm still not at all sure how all that works on Intel and what
we can sanely do with them.

Supposedly Intel has a means of setting P-states (there's a driver after
all), but then is completely free to totally ignore it and do something
entirely different anyhow.

And while APERF/MPERF allows observing what it did, its afaik, nigh on
impossible to predict wtf its going to do, and therefore any such energy
computation is going to be a PRNG at best.

Now, given all that I'm not sure what we need that P-state driver for,
so supposedly I'm missing something.

Ideally Len (or someone equally in-the-know) would explain to me how
exactly all that works and what we can rely upon. All I've gotten so far
is, you can't rely on anything, and magik. Which is entirely useless.

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkBOHAAoJEHZH4aRLwOS64+kQAKlCijXlyN6C5acpPZH1Yqkm
+32a0/SWifD93YqgslU2Vq0ml9LhSJ+5FyTxZxJ80/hkGaAf3tbvCfq7u2UOJCzS
HSuXKk9ZSLl+hTGD+M1MSx3YMFUUWyb1+9Gm+oaaV2FydG51eN/7c5/QEzT9lzKf
PgJnlPi8TnI9n/FYJ3nQ134lBlmHvwWvyTTkzi0FvdChyUj2VlhHyf5PybQcZdM8
zDvcMt9E4a825XDyFK74ubqE9RicCydRg8e3aVSMvKUJbsMg9QKJzoez34eAwo6P
H7rk3vU6nwIJCd0/OQwOkAi0ENU+WyXxg+SxDsQ+it67YeRGa0zBLHQ9IGw09/H/
sstGV1+pR7ep5/NMGBovAG8ukBxbABTU+AllrDOlffBhWxTRSl/V3nA0ZPPE8hNX
7aeIxHAYYXGFSe+JI5JfhECVQSXvDi92Sjg/MSz0KRvliTTE8F9ly3Sppk6RU7Gd
2ZBfNXBy5W11htNTHpUjumFiOnI/cjF2fvYUCTDbnA11Eo1iDPKOrcBqpujYNEiL
86s156ve23zDpRx1D8VblyphlHOIo8kHiZLdSF2N91ZLYgTEaVO7wEqL+SNzzveS
8wFAbJ2r31UE103YqvZQIgX/u3o4Z05DHu39dmtt5UG3OAGM4oAdCTY9Lnt/7FJM
ZzFMi25FO5NUoHgpvXol
=V40h
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
