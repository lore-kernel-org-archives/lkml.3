Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaEHQt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:49:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:44724 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaEHQt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:49:26 -0400
Date: Thu, 8 May 2014 18:49:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        nicolas.pitre@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/idle: Reflow cpuidle_idle_call()
Message-ID: <20140508164920.GH30445@twins.programming.kicks-ass.net>
References: <tip-cc6vb0snt3sr7op6rlbfeqfh@git.kernel.org>
 <1877683.4pfeUuvFZ2@vostro.rjw.lan>
 <1591569.1rC3xo6G18@vostro.rjw.lan>
 <20140508120826.GT11096@twins.programming.kicks-ass.net>
 <20140508163346.GA9330@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gpOboRovIPmaBszt"
Content-Disposition: inline
In-Reply-To: <20140508163346.GA9330@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gpOboRovIPmaBszt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 06:33:46PM +0200, Ingo Molnar wrote:
>=20
> * Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > On Thu, May 08, 2014 at 01:56:18PM +0200, Rafael J. Wysocki wrote:
> > > The cpuidle patches I have queued up so far are on this separate bran=
ch
> > >=20
> > > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-=
cpuidle
> > >=20
> > > in case you'd like to pull from there.
> >=20
> > Ingo, can you do that? I think the patch I just posted should be=20
> > enough to fix up the conflict.
>=20
> Yeah, sounds good to me, I'll pull it into sched/core.
>=20
> The patch you posted is essentially a replacement for:
>=20
>     52c324f8a87b cpuidle: Combine cpuidle_enabled() with cpuidle_select()
>=20
> when it's done on top of sched/core, right?=20

tip/master actually, but yes.

--gpOboRovIPmaBszt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa7WQAAoJEHZH4aRLwOS6GeoP/2FvC/PdrUhuxVqQIRpx04fW
jR1Lp2/VQKFvZRiiIB8Kck1IFarvHqmHw8aM/MjvF/RKhYKocnrdyMSJ5V0ARU1D
4qaEzz4MbEoQg9Nycgez6Qngg/K+VA13l56HCvPYo45pQOfgLdH+RXawqCQvcBhE
rCuTrGbbwIk930qRWves30H7WPxQbUmRqK5JVTaR9kY28HOj0v4XbXG4L54L0RbF
lg7vbBOH5+P3xj6oxJXojZyMdRlL7Umd0hFY5KLF4izkQmV0Al/ekj4AbIglCETX
9ZgOGiL/u6zt1dpfqh6QRekrNQtA1bihf7s6OQJMFfnQN1Ys2/0MxmV09T4Gu6A6
e7LHkqI6OsSvbOLpO73CiIq2Gvx/09ya6WIk7lJixiw8kKyjIAxPmjtZwxdj/n6c
MAsgea45GLDyENk7FWhmbWOHvs7S9f1gqN4o05LQYmZF1u1l1rNTMkC9SBEtFkT2
qFex2F/awTFEuG58xtvo4lPoug2rSS2UrWlOZcnY5yf3WTYEgeEHbiEkVf+wxeZe
sNzZxxcLu/lk392EzS9w8CFlAhrwFit/r7vqA0lJNGCtCidsPQ3Nk/oUcB6k6UMH
Xpi5rCxV7qLGYYs5sJBqJAlqfwZlqyUn9ETsP8IGwq3xmEceE2UFkSBIKCEmK+Z4
9ihjAQdNIAS7Ug2UpeSU
=qRHT
-----END PGP SIGNATURE-----

--gpOboRovIPmaBszt--
