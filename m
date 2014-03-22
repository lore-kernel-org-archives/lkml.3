Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaCVRiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 13:38:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37920 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbaCVRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 13:38:17 -0400
Message-ID: <1395509887.2770.72.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of
 commands
From: Ben Hutchings <ben@decadent.org.uk>
To: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 22 Mar 2014 17:38:07 +0000
In-Reply-To: <20140322165145.GA12870@kroah.com>
References: <20140308010611.468206150@linuxfoundation.org>
	 <8891481.xyaW2OauMW@tux200s> <20140322162501.GA13385@kroah.com>
	 <174441141.AshFyuFNQG@tux200s> <20140322165145.GA12870@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HJW55eP92Bg4Ssdn0BWG"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 78.32.9.209
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HJW55eP92Bg4Ssdn0BWG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-03-22 at 09:51 -0700, Greg Kroah-Hartman wrote:
> On Sat, Mar 22, 2014 at 05:28:02PM +0100, Andreas Sturmlechner wrote:
> > Original Message from: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >=20
> > > Does Linus's tree also have this problem for you?  Or does it work
> > > there?  If it works there, perhaps we just missed backporting somethi=
ng
> > > to 3.4?
> > >=20
> >=20
> > Other trouble aside, iwlwifi works fine - writing this from today's bui=
ld of=20
> > 3.14.0-rc7+.
>=20
> Hm.  Any linux-wifi developers have an idea?  I can always just revert
> this patch, but finding out the root cause would be nice...

Andreas, could you test whether this regression is also present in
3.2.55?  This patch is based on my backport for 3.2.y.

Ben.

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-HJW55eP92Bg4Ssdn0BWG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUy3Kf+e/yOyVhhEJAQp1LxAAmJMaV1D+uE3WHiyXrRGE+Yvl0EXr6aQy
bMqu2zaPlz9qmrHRn9FL1uK6MBbuE94afjq6XmywBsUORIg7M8yQDTiMSpog9yCV
SLkK+1zSqabHrdZ+1AHKN/exqXE07YYyic4JxDWB24UjmAN+bl6LKekD4xe6ebZU
XUPIg3SuTMrMCwbb0i/zVCtkZZ7kIuVfC2aUh+pfytKmHhLqV+yvkRAZwCDOoxT5
DHprsmkq5giBRP2P9QUAmjDzVQVLXQewbhfyRWPRHrGdwx1zbFtmyx8aWdNINw4Y
yLbcGi1bMVp3N141uSNy9dOXP2Dm4RkIy51v2/Ps7BekqvckoXuCrhOYylyxtDCU
6SEjvlxi5Z95U4GgiKlx6+VypF5Y+Wk2CVZbPtVCLEE4OkAnT9q5UZWa0kWClPg1
DRLPdBa3LC81K+Z/Bcn6eXd6jZAAHgJBI+Wh3hyX9MpJ4lWWr+jlTxuFTLt1/h2/
ufr7g8+hMXIc6HBmVpJinSqESpmO5q3guFeo+KNDso+fg675OrxE48dkL5MXVegL
37MTAAyZlqyOjT29msPhFkzzgGFLfeX4D+PySvaQOs935miqyXMboWzW4tv9a0iH
vA3AbhF0HvVwSyULtztk7ji2n3oCvu3pQz1Wm8M3tMtzN/40eAzXoKY9R5au3h5u
MPTFrFz3OvY=
=Zllu
-----END PGP SIGNATURE-----

--=-HJW55eP92Bg4Ssdn0BWG--
