Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127Ab3JPUvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:51:20 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:62248 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761317Ab3JPUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:51:18 -0400
Date: Wed, 16 Oct 2013 22:51:15 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: NeilBrown <neilb@suse.de>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131016205114.GD6579@mithrandir>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
 <1381949500-501-2-git-send-email-treding@nvidia.com>
 <20131016200645.GD10651@twins.programming.kicks-ass.net>
 <20131016201410.GA26785@twins.programming.kicks-ass.net>
 <20131017073100.2cab1ffa@notabene.brown>
 <20131016203506.GJ2675@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q9KOos5vDmpwPx9o"
Content-Disposition: inline
In-Reply-To: <20131016203506.GJ2675@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 10:35:06PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 17, 2013 at 07:31:00AM +1100, NeilBrown wrote:
> > It seems to have moved to=20
> >   git://gitorious.org/thierryreding/linux-next.git
>=20
> Uhm.. what happened to sfr and why would we trust gitorious?

sfr is on vacation. Back at the time when Mark Brown and I volunteered
to continue doing the linux-next trees in Stephen's absence I didn't
have a kernel.org account. Also we decided rather late that we wanted to
do this so there was no time to set things up properly. We had to make
do with what we had.

Today's next-20131016 tag is signed with my GPG key that I use for my
kernel.org account as well, so that should make it about equally trust-
worthy as anything I'd be pushing to kernel.org.

Thierry

--q9KOos5vDmpwPx9o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXvxCAAoJEN0jrNd/PrOhQbYP/R0uwMOi7PYrvLufplu3snuk
itBulji/2wjNbkhlkWAcXXEiLIVmjUrHU571LdBwg/jbALbK7yQTWHdiPcsRfWCA
RtowhA/lsHGsl73ofQNj/K+VhrmXIyjrrTOSEz8Gd7FKoFhihk37JIfxibmw79bO
8E1F5iY5PwNo2ZbNiURR9OBY1sEp6JM4+f+PNLWmwS/bGR0NUmz0I+SN4oln6yvX
nWHBpCaH4sTCCPzVqPtRtGulnU2/CBgknei7HNEUiqaVU/XJXkOblg0l/DX/r6/d
tUBte9gQ+ESnJbBV2JTYkzf/kMC4Eawv4QmM9+GecRvRhmHZ3AVqLBYYKD0coaeq
gUdFglXtoHJ3aEhw2Q9n2mKOHax9eJU4lgeqM2L/MqwPfa9d15aHwlbTsBVGcBvr
nj1e2nNOhHCAS2+wqGjg8yni+nk++jCYv76zg65fatTgaNQqxAsQWtWnMSYbrAwZ
rkR0L10h4cVmxMsfhkeenXUx36wPm/QtnTk/XWngqfUjxNVarkg0dPA+FJZK8TiU
DFMaxu2IkZ9ulM7LFBzxn4jlXNwo26p2MY/Ny73gg60M87XfJSxkhXHyKa5u6diX
YmY1+ncVeVKtcI+NPnrZbRKDOW+LcfrvMxqXcf+O2g87Y4+sX1yOV3jrTdgTF7KQ
dYDpwbITHbiVI+Q1L+VF
=e0xY
-----END PGP SIGNATURE-----

--q9KOos5vDmpwPx9o--
