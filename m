Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbaJTX3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:29:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbaJTX3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:29:07 -0400
Message-ID: <1413847716.6046.1.camel@redhat.com>
Subject: Re: [GIT PULL] please pull infiniband.git
From: Doug Ledford <dledford@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 20 Oct 2014 19:28:36 -0400
In-Reply-To: <1413499938-2378-1-git-send-email-roland@kernel.org>
References: <1413499938-2378-1-git-send-email-roland@kernel.org>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-pz5klfjjbivPCJeG1xlw"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pz5klfjjbivPCJeG1xlw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-10-16 at 15:52 -0700, Roland Dreier wrote:
> Hi Linus,
>=20
> Please pull from
>=20
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git t=
ags/rdma-for-linus
>=20
> ----------------------------------------------------------------
> Main set of InfiniBand/RDMA updates for 3.18 merge window:
>=20
>  - Large set of iSER initiator improvements
>  - Hardware driver fixes for cxgb4, mlx5 and ocrdma
>  - Small fixes to core midlayer

The IPoIB multicast locking fixes I submitted for 3.17 that you put off
until 3.18 are missing from this list.  The set can be found here in
case you've lost them:

https://patchwork.kernel.org/bundle/dledford/IPoIB%20Locking%20Fixes/

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-pz5klfjjbivPCJeG1xlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJURZq/AAoJELgmozMOVy/dISEP/jLXutqB1nnWfYX0572X2DYA
Zfb4VBEbqb03gc47s26vMOeO8GF/UAAyWdM/oZ3yEBq8MoS0JMAUHoWd+7RCfThF
NbdQFkBhdzE83PDc9ZIMyvLngCiRsQ1LmtP/7bxwLsMhmxVes5NRECFQTmXOMZwe
PJ7okFE9jOnLaYFNTBOXOEaRli+ThE0aYzcC9c/UCAWC0sHnDJssvgAg5ZKfDuTP
uYKWD3N+vU4pQZ30NiE742pOjBqgUjnEypSovdLG+9F4WJxPvNc9S15BpdV+sE/z
xbggA8tpFv66FEBmm1O26oZzz6Be8JD3lQ4QjrL829e50x4ui/F1jHOzMM/0gqcS
Zeh3ahxr/a972EMP7B9GCV1L+VkSyj9zDGuR/RNJ8ml0rVMc+R3szno9CWW1letI
R0IACEJfFwl7acJOVJ38sPqO694RK+btBNinjGCH8OnH7wNxloVpv6X9dW/n2B4R
2UdO3/peQ7EqlvejurDTALBgN+ycJ+AQ/QK76h2Ha7J+ou0wt9wveTvvOkyA0OmP
byaZnCtsCufRywKBhJzXMttkVjdL4y69Db2rENjR41pBNxSLZp640KfU1CgeYAUP
w/SU8e5/IOOi79nkg1WluXerJl0AO5Vi5dEy2i0QZd6m04v+BrB+112dnrdVU/42
oNInYDgjBAyASmYreRNH
=gkV1
-----END PGP SIGNATURE-----

--=-pz5klfjjbivPCJeG1xlw--

