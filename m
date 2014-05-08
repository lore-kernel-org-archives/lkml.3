Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaEHP0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:26:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60597 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEHP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:26:21 -0400
Date: Thu, 8 May 2014 17:26:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <dongsheng081251@gmail.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] treewide: remove all open implementation of
 nice_to_rlimit()/rlimit_to_nice().
Message-ID: <20140508152614.GC30445@twins.programming.kicks-ass.net>
References: <e1f9c9f2023719e0738e16cd6807c74c68b08fad.1399532322.git.yangds.fnst@cn.fujitsu.com>
 <a568a1e3cc8e78648f41b5035fa5e381d36274da.1399532322.git.yangds.fnst@cn.fujitsu.com>
 <20140508143404.GV11096@twins.programming.kicks-ass.net>
 <CA+qeAOqCo9g=tNARWf4JESLZU6sAoSKYDvmfGE6OOmJQhajyDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aQ0PHH3iiKbaMI5N"
Content-Disposition: inline
In-Reply-To: <CA+qeAOqCo9g=tNARWf4JESLZU6sAoSKYDvmfGE6OOmJQhajyDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aQ0PHH3iiKbaMI5N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 10:51:13PM +0800, Dongsheng Yang wrote:
> Just want to avoid using hardcoding of 20. If no, there is no meaning we
> collect
> priority related information into prio.h.  And convertion between nice
> value [-20,19]
> and rlimit style value [0,40] is used by several callers currently.
>=20

Yeah, not really a comment on your patch, just a general observation on
the thing you touched :-)

--aQ0PHH3iiKbaMI5N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa6IWAAoJEHZH4aRLwOS6sSIP/0nj6cxXq3jEb2gYXMpJytiN
DZBhzYPCfM+nFJedt+B85KmdQCaxc6Lc2u0Iu/EGykybezh1AaXP+aLlAzLqx1W4
xatxjlHM62rlTgcLfAL1zjtg8O0Fkb10O4gZczpLsUITKNKIiGeiWxwJB0U7nEqk
tweWkJsa3CCjuBZOp1S94/Cs2Va+iRm3KY1rokkk2CulLXRjhZHCwJThHVjVl4+V
kHa8cpeYh7RztqqlkeeB1d+5N1F7pORYsPdNnp+fMZVzRD0NTjWCuidVrPzJSM8U
gMxFzMVk0Pp5Etgi4qacprNb4uS90FlbkjjFXxCBBIVpdiKTVrR+Y2B0rBgcwqC6
r+lotIEZYsxy5zq4vSiLAb9+8b2kDi0TJvqCiRMsQM1ybSFyZJDHbo1CspcC4iS2
I6g8BN4NgIM6157FA+Zk3NPGF6LSlsA0UxSTbBJ6ZgEW9Mv0U8UUxqFuF5aWdW4Z
cgosRGgnYdMvDZ8AXLWUsSCr5olu5JQdlAPMeQWf2vswS62iPG+ZRvG02yM7xtrL
cCBvn0HmKwGQH/2ZbnwI0UOBnru6LqXy/nMUPeMIo8aPBx18KZCPrK3JxvYFkzd0
Y9ilEXNVNoz7aowI5kGKvi+vKpv1KPNmctA2pLg61RmfdHpz6Q8bI8hd+YAA6VVl
Z0TQ+l4m1MadncaHGR6j
=k0i6
-----END PGP SIGNATURE-----

--aQ0PHH3iiKbaMI5N--
