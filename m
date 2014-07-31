Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaGaEGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 00:06:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaGaEGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 00:06:38 -0400
Date: Thu, 31 Jul 2014 14:06:27 +1000
From: NeilBrown <neilb@suse.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Ian Kent <raven@themaw.net>, autofs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] autofs: the documentation I wanted to read
Message-ID: <20140731140627.5c5bfb06@notabene.brown>
In-Reply-To: <53D93B5A.1040707@infradead.org>
References: <20140729120017.53590fad@notabene.brown>
	<53D93B5A.1040707@infradead.org>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VY2gxxN+burVxzaGlvESzde"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VY2gxxN+burVxzaGlvESzde
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jul 2014 11:37:14 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:

> On 07/28/14 19:00, NeilBrown wrote:

> > +Directories further down the tree depend on the *max_proto* mount
>=20
>                                                     max_proto or maxproto=
?  or either?
> check/fix other places also.

The mount option is "maxproto", the internal variable name is
"max_proto" :-)
=20
>=20
> Thanks.  Nice job.
>=20

Thanks so much for all those improvements - I really appreciate it.
They'll all be in the next posting.

Thanks,
NeilBrown

--Sig_/VY2gxxN+burVxzaGlvESzde
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9nAxDnsnt1WYoG5AQKMhg//R3YlNTvX9wlsVrQ3f+8CVy6U1/Y9W/7j
u1VzyrRfeBTQFjxDWJfM0CqZuSCOR2Of7jPtVtJxVKkFz1fu+ig+9cRaFHfVjWNb
87QxEktDbgFEWDQFLPQ5tBqn5+88M5Y1ZKIz5MWq+5b0vqS0QPhXZUlWK9WOM9Kc
bSf+y2g2UUgaTuG+Z4qnqbjnG3X2nOY3aPHB7/chpMoQ1E0ifRaTHe0c8XvyxRf6
2fjzTNS5WZek8THiL9IdcgEUNhCciys7RpAOXhFGn2Kq9cyDRMMdr3MPRIzAxhA6
5rqM8hnPUUfuIDpA3t2Erjh+vZrnRoFyyfG1tg5idiqplyHtPwoHopHFpsT1KaIh
RWJP5fMui49in6l39B7UW0j9f/QXy+8ZxtngvxZy8EX1N4XWaLQnA06lLhY2seJ+
cfHcLKZ0pOzVlG4xnhrlVkJ80FpNWWbBa+uBMOpK5k4/hspC/ZLY3vjkXDuiPjgQ
3VkcQx58AKaD21poZs6gDw5IudY7Bg2Ybib/6Eo/V5npBat3MD6NmQiu5ul/SqVX
iNNFSFsu2OrQdvyFEv3eUrHBEuN/LZRpra+cEiKqNkG3HPlC7mWB4GUIex8qOvjZ
sVQqVTdOcVOhTRoWO4RVDMtj+cpE/70Ds+u664+yr2eTKP+6lkJcKafKv7zoIKhf
gncrODesEjw=
=GTGW
-----END PGP SIGNATURE-----

--Sig_/VY2gxxN+burVxzaGlvESzde--
