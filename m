Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaFEM1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:27:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaFEM1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:27:22 -0400
Date: Thu, 5 Jun 2014 14:27:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605122715.GD6758@twins.programming.kicks-ass.net>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <20140605081742.GC4926@gmail.com>
 <20140605111110.GA26771@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M38YqGLZlgb6RLPS"
Content-Disposition: inline
In-Reply-To: <20140605111110.GA26771@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 01:11:10PM +0200, Ingo Molnar wrote:
> Unfortunately even with the latest bits from you the breakage I=20
> reported weeks ago is not resolved:
>=20

crap, its the qrwlock bits, I fixed it for the config you gave me. Some
paravirt crap header hell thing. Happen to have another .config?

--M38YqGLZlgb6RLPS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkGITAAoJEHZH4aRLwOS6J54QAIEIzydA1KqS8ku2CtR3hN9L
1MLLSjMDKXSWwHRSYtcd/dqEniHjZ2Vec7eSEuRCX8zWI3B8B0phr+n+RYyxs58r
CXRHg7Sojb6j4aytU9JiFmIA81yfo2+hPMkyRp8K1RTBWA6PtZEyaH+C8Zh20SYV
spdJhsa1RXcVMd6myCkKTg5sAQtIYsZIMc+vKqsz9iNDK6/ptWVrvcJbcM+TL4gR
vmRq2Jw0F6OTt9GW576sG5vYr2jkF/QWHP6J3Jm3VXIUVjjJCzXiHA9oFVfX6kx+
J9X6i2OiB1nnxUk19+VZwSp1mlbstH3k2I4kJfUY53g2xZ9YDfUj2zdW8PHTep8D
KdBSvfFc2XkXBQMHoJSA0OV1CNRrrE4fGKC1wnRBs6AD9UyHOU9wvNpv/YhAwXvy
HdQKCTj0Mn8WMF7IcX74iioBO0JDbWqLuTl5XXnamzPcSfA9way3BubHjdEQPvpQ
YOaZ4SGN3ELoRtwjnMercuZcKHKnP6c8HU5dlmBkTVLmKasKhJfirX+8PPJWSWQV
n4W1uIqeYYKP7RtZZpazPCi8IQcvkpiQhW49DPbMjWOPIQFufQdBR9dwztVbXkJb
ELwwgCGpOvwnysparvipRn6PmeQ+5Cka/3sU8FGdzkVo7++pAZdFA87ix4OThbgX
gqUal5ecHUOkv5ZA9+9R
=puPK
-----END PGP SIGNATURE-----

--M38YqGLZlgb6RLPS--
