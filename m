Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaFDKaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:30:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:46003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaFDKaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:30:12 -0400
Date: Wed, 4 Jun 2014 12:30:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140604103003.GE11096@twins.programming.kicks-ass.net>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OvQTJYj2nBz/p38G"
Content-Disposition: inline
In-Reply-To: <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OvQTJYj2nBz/p38G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 02:50:51PM -0700, Davidlohr Bueso wrote:
> On Tue, 2014-06-03 at 13:48 +0200, Ingo Molnar wrote:
> > Linus,
> >=20
> > Please pull the latest locking-core-for-linus git tree from:
> >=20
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-co=
re-for-linus
> >=20
> >    # HEAD: 3cf2f34e1a3d4d5ff209d087925cf950e52f4805 rwsem: Add comments=
 to explain the meaning of the rwsem's count field
> >=20
> > The main changes in this cycle were:
> >=20
> >  - reduced/streamlined smp_mb__*() interface that allows more usecases=
=20
> >    and makes the existing ones less buggy, especially in rarer=20
> >    architectures
> >=20
> >  - add rwsem implementation comments
> >=20
> >  - bump up lockdep limits
>=20
> So I guess the rwsem optimistic spinning stuff will be routed through
> akpm then (which is already in -next for a while, through -mm).
>=20
> Also curious about why Peter's rewrite of the qrwlock_t was removed from
> -tip... I noticed it was there for a few days then disappeared. What am
> I missing?

Ingo is 'missing' most of the time, so while I sit here with a massive
queue of patches its nearly impossible for me to get anything merged :-(

--OvQTJYj2nBz/p38G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjvUrAAoJEHZH4aRLwOS63mUP/RaZyNk7EfGmCh6ov89lU7sH
EQQMTKOygdUWKzGqbMAOHRV45XUNs6CLekFc5GGDoYUQ2vDWvVVwl4Hjm1G7U8Pt
PqrtUef1ppRFhM3NqBcWkBtqXyTASG3moUH5BQ678sp7RMlQYh0+JXlkRF4jzljq
Cq6dgMq52dgciHGiErrUgfGfHds/y+fyC0QIKmJG2kegeGzZV1MiZuk0rNyGlEZ0
Rde5KVmJdgF14pTLqsq12WAEpmL+sfJu6gqGdQ4cbjODcDN3zifzOcg0vXv9ZKq8
idMBzNM4mwp37yuUMjYELE83Zgal3dNVTCUVcv+Bwc21iHsyILRGqpleF2yi2A5k
quBc2yzGPpGBrH3A2sbK0B32LU5nJ2J8Gk7crZl8/Cd64qF6EMFpKEYEFlbpBliD
vnqueO4RFdPIO/0ohtbsqWZTG70eeVg33xMAF+xzxxmkqFkDItNu0nHDXS1Bda8u
xd3hO2IVugaTKSTP+BabIgIjXhLmdMLShvV7o6XMoyKJtYmoZ9clrOApD42zD4yS
34S3QxOxjdDOzkpTkRoeXLX10Ti/2/PIBQtJbI6CT3QhA/vkkycqE+vunYCKOiP/
UwQOxxvThAZ/7x3A4AUNyqmzzHPhmuQttu1h4K7S/SfC0HymZAC4NgB9tmGSQoF7
LywN7qWIclDqoLrVh6cU
=1rzR
-----END PGP SIGNATURE-----

--OvQTJYj2nBz/p38G--
