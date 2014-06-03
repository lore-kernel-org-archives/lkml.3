Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbaFCIch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:32:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:40366 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaFCIcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:32:35 -0400
Date: Tue, 3 Jun 2014 10:32:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: sched: Disallow sched_attr::sched_policy < 0
Message-ID: <20140603083228.GN11096@twins.programming.kicks-ass.net>
References: <20140602021319.9A5F9660C19@gitolite.kernel.org>
 <20140602202204.GA26649@redhat.com>
 <20140603080826.GK11096@twins.programming.kicks-ass.net>
 <CAFLxGvz4yKJfWyRqh5wnG-05m9P3oxcrvVZLH-Yap8dFz-0ctg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uTOHp36N6S0WjZTp"
Content-Disposition: inline
In-Reply-To: <CAFLxGvz4yKJfWyRqh5wnG-05m9P3oxcrvVZLH-Yap8dFz-0ctg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uTOHp36N6S0WjZTp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 10:15:44AM +0200, Richard Weinberger wrote:
> > Once upon a time GCC also did warns like that, but my compiler is silent
> > :-(
> >
> > Yes, that needs fixing..
>=20
> I sent already a patch for that...

I found it.. thanks again :-)

--uTOHp36N6S0WjZTp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjYgcAAoJEHZH4aRLwOS63o4P/2P8ec5A07KGmrqvoC+zzGnq
ucYS+PZH+xiFvSyg8MK+3I9Xzc4y8edSA8sBiziA9aKmqiB2pnXFymkQKKt+xNNa
V2Ujr5Md2dsF/o+EIcAu81NggSYPLRHCb8YLZgIpZUP4a+hdzi+W8Md69CScapgr
VSDxkPz/wlTlBUOgGUhQisuBo7xK3DZDU1W0RGaHXgkvIvTamhlkkiR2F7bS3ril
RQ3WzYvHiaUk02LRD8E+uMck5OR46ffZQIuc4ko2ey1/mb5d8EQwwg/O3tnfry2Y
23RT/p8p7BGOsqVz/59yM6qZCkao8N52XNQgWoY4d+3DxkvdA4BY6oKGwmliBRnC
umW5m9FtxEFIT2nlA+j0gRMFv9uobkWu0LI0BD87FWIQeGfeGeGPXp4OaxpDqfPq
dMwIv8WIC+ulD2qzKr57X0hTUN3N+NaFqZZd9iry3gs9izuly8/IqJ3ac3PMrXoj
btvbmCI3eSr6dK5WwQ4H1V6ZMaB26/r7VG6QzWgGRi3qVQgnvRDeiNx+kM8Gx3ix
2g7Q4oeXdrLZJV4MCm8f/4pJKcbQUw8rIuKxVAqF1fMJS+6Y8xZFXZ3wJu2Br9eF
KjXSab8r5bjlZK+O6cpHUF6uW+5FI6DZMfTMTr43Kq9nYScMq0MbJesVaDvtlJfB
k1CUzg7UTRQ99TPFtOHW
=5+nv
-----END PGP SIGNATURE-----

--uTOHp36N6S0WjZTp--
