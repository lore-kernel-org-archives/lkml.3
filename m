Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbaLKSuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:50:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45898 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758024AbaLKSuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:50:09 -0500
Date: Thu, 11 Dec 2014 18:03:04 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v5 00/61] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141211170304.GG8739@lukather>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141208061746.GD16827@intel.com>
 <20141208141807.GC8739@lukather>
 <20141208162843.GP16827@intel.com>
 <20141208183853.GG8739@lukather>
 <54861D04.8000102@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wJeYCwfJgfFvSPOo"
Content-Disposition: inline
In-Reply-To: <54861D04.8000102@metafoo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wJeYCwfJgfFvSPOo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 10:49:56PM +0100, Lars-Peter Clausen wrote:
> On 12/08/2014 07:38 PM, Maxime Ripard wrote:
> [...]
> >>And lastly noone blamed you for being late, if things were rosy they
> >>would have been merged over the weekend and been in today's next,
> >>but...
> >
> >I totally understand your point. And I actually am a bit uncomfortable
> >merging this so late too, and I'd actually prefer to have it merged
> >for 3.20. But this is a huge patchset, and I'd really like to avoid
> >rebasing it forever.
>=20
> We don't have to pull in the whole series at once. I think everybody agre=
es
> that the approach is the right one, so the first couple of patches that w=
ork
> on the framework should be good to go in. Same goes for the drivers that
> have been acked and tested.

I'm a bit skeptical that it is the right approach. These patches have
been here for monthes, and even you failed to ack and test these
patches on the drivers you wrote. As a matter of fact, only Laurent,
Linus, Ludovic and Stephen looked at their respective changes. After 3
monthes and 6 versions.

At some point, cleanups have to come in.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wJeYCwfJgfFvSPOo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUic5IAAoJEBx+YmzsjxAgyPUP/17yO5gF8Jj3tF6GfaNzDOSr
QIhSZWyAgb++85rSC4X0YyR898gwAY/kq6p8+NT1mX65GO9eIchgHRx7pSH3jdCE
5x3VymIO5ti7OVgO4oyvW7xGkpxJcLjiStnd+1KubTvMSq9MEoBsGM0l1XP7BitF
kbh4/m5eP/2bHIjREpq1Os3jfWt+qR6p7qKBJZzxCPCJLJm18vbrUswWMUKJGdC2
CMfYGeBlo6Db00rKQd1BOYlL1wqT1BzlBKFXJa7lTCb/4KQIs/Lhj+bLgVnvSBvx
bb0B6PRI8UPaK/3QCv9jdK+Ie6wCvVsEidrYGEsW5zD/ftloQ0eJ8r6sXMlYF09Q
ofYFgIKwZ+H03WZT0BCDpzwDQIYH/kW+ixsSnOy61JyIjbZwCpCKCWcYsI0BKL5q
a7InucD3aQYPDPuPhH+yrMUOiLu6frsZmI7DlqphjXy6+Qws0px7h35c6OY0tzvF
lp495pfpxD9dpS1d44QFe7AoAqMCOPQ0GtBYOJ8a5ieMP4cCg5A0Tm/YCkFdtT9f
v+FMj8gqeqhpu1oDI6Ek2O/m45xhknNIRx82fov8og2PhDfPWcbtrQNjLHQ6oKaM
irj+BnltHahrELQ8W0cs+/nQEltZRW+JmgqaYIZDa++xaM9a9Cm3Cn7g2Z5yMDJP
zOyOaxxMKvxZ+/BFx2yL
=mg8x
-----END PGP SIGNATURE-----

--wJeYCwfJgfFvSPOo--
