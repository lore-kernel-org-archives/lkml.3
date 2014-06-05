Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaFEMln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:41:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFEMlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:41:42 -0400
Date: Thu, 5 Jun 2014 14:41:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605124137.GE6758@twins.programming.kicks-ass.net>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <20140605081742.GC4926@gmail.com>
 <20140605111110.GA26771@gmail.com>
 <20140605122715.GD6758@twins.programming.kicks-ass.net>
 <20140605123512.GB1392@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
Content-Disposition: inline
In-Reply-To: <20140605123512.GB1392@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bi5JUZtvcfApsciF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 02:35:12PM +0200, Ingo Molnar wrote:
>=20
> * Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > On Thu, Jun 05, 2014 at 01:11:10PM +0200, Ingo Molnar wrote:
> > > Unfortunately even with the latest bits from you the breakage I=20
> > > reported weeks ago is not resolved:
> >=20
> > crap, its the qrwlock bits, I fixed it for the config you gave me.=20
> > Some paravirt crap header hell thing. Happen to have another=20
> > .config?
>=20
> A simple 'make defconfig' triggers the build failure for me:
>=20
>   kernel/locking/qrwlock.c:24:25: fatal error: asm/qrwlock.h: No such fil=
e or directory
>=20
> If I apply the minimal feature-enabling patch below on top of the base=20
> qrwlock patch.
>=20

Well, that second patch which you neutered below would've provided that
asm/qrwlock.h.

Lemme see if I can find it with randconfig with both patches applied.

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkGWAAAoJEHZH4aRLwOS61wIQAIkwbevXfGsvzpijp/PT2d/P
jPrKmt7fA2n7PLl6pbfY9gRUsbGSa9LueJEfBjhlr2mEsNpTSGt8X59iylT9A1vG
UsG6wCJlCdXQkumJrjsMZn+t3lEXnd0mXhOcHVIKdJ3ZZldVGi1gnqw25s0/LrN+
t99lDWMjvl0Hy9T5zbliH81xUVeAbeWR776o89U3vrBmo/n/KxkNUIJcCZQFg7fH
gwzW+34sgQ9xdBlXQee81v/IswC0V272pn9oC9bU0KtlfueF0U1n0CUU40gGTboo
kBzxFAnZRafw6O4kIuvn4z+9XZ6upVMDfMealwd34zx6TPJwcHViYOuMLzW0mUGT
ihxOVLTE/9NBNlt90KEw/lgRbFORHRc2WsO2V6BRuK9gUHqtsgYahcsT1WrWdXRy
xVbAuD+YCovwoRvq/9CV/pe+7Ws3hBfFyBgufGGA2TbaIgx8EDRZClTBJFLKfju1
PiusKKSftf8jUrCkaBdT7b1hgN4vraO3Hz1XCGUTey8doQDaiPMjZGFyRsSF10z1
GdYtDZFHpQE0zSWJUSE+EH5urxIieIvtWKcBLg4ymPKixugLUVKnvoqHI8gTugxo
57ZlYc+iDz/fUMa8jhnUSIZExzyOdX5E2YFGx74xx/u+CGCoqBOXbq/d8H2+A5Z2
8jC9ZYKjT3IShIAWSmez
=T42R
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
