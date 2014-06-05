Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaFEJVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:21:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaFEJVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:21:43 -0400
Date: Thu, 5 Jun 2014 11:21:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605092130.GC6758@twins.programming.kicks-ass.net>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <20140605081742.GC4926@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <20140605081742.GC4926@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 10:17:42AM +0200, Ingo Molnar wrote:
> > Ingo is 'missing' most of the time, so while I sit here with a=20
> > massive queue of patches its nearly impossible for me to get=20
> > anything merged :-(
>=20
> Right now I'm somewhat 'missing' because I fell ill right when the=20
> merge window began :-/ But I merged all your pending bits shortly=20
> before the merge window started. During the merge window itself I
> try not to merge fresh patches.

Yeah, no problem that, it just shows we need to better arrange things
for when you're not available.

My/our quilt workflow works really good for me when you're there, but
its obviously somewhat broken without you. We just need to work out a
(better) fallback case.

The timing was just somewhat unfortunate.

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkDaaAAoJEHZH4aRLwOS6qgEP/1lrKBp5eHB+mkgLdXmA6oQX
K+iHJyz3jgjwq3q2dOX7B9b3b06OolZNoIkue+/b7r5xVUNBQRdd4mTw0aO1k2hR
z/8JMtczvwojt3TIyRq8ynMMtK+3cJ+rIrCCYsnRDCETArbwmRzKwUUs/tKhOSJp
DgFSyxjTySzLSxgXz9uM84mzQAi0k9pKDwCbpZajvKSr6niG+qpl1eTUIDQzVvIf
yMBz/UkXcOGbxEZ/SN5QqRwAj10oU+tpIoPXaeXGoVj3B5A6APT5JZ3NFmRPS+p6
RiWi3o5PImTmdLhsfKgzUvKOy11ltI3Si3EP550LxHecjPxaf7mt1OpK7CXJi8eK
ufuQY0uKaImHABKIS4YOimzBVhnOgfbO24VCHfQfZ/vIgZABxLBw2oetnuSULz+V
F2tXTYpEcXjmNxdU0HnbImSJTCp9a+Kv5/d2zIYk56z0Qp00QhttGhkrNBM7oT+0
Vkf3Ej0p5wSJH88LdVvvPWDk2V7lsFIfVhNBazaUsmS3al63fABKSpfvV2KZ6hzi
E7bkNYHCbITINAj+8R6EO8z7WqMhHfBQPzzTgHwlWWeWvyhULa1nD8GLa0YwlFSU
3ct13p37PtItTb926H939X6grSjB7x/uQKOZAmTWzSzEbasDe0akgobfKEmvf0UT
c9UbuVjuNwB9nyj9DixS
=RVoj
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
