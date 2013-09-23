Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3IWACc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 20:02:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45986 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3IWACb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 20:02:31 -0400
Date: Mon, 23 Sep 2013 10:02:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: old trees
Message-Id: <20130923100214.7e28c4203211bcfa9e07a2b3@canb.auug.org.au>
In-Reply-To: <20130920183517.GH5707@phenom.dumpdata.com>
References: <20130917170124.0afa2e103a9977355ad7c72c@canb.auug.org.au>
	<20130920183517.GH5707@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_10_02_14_+1000_9_Z9/AfSi05/vbfg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_10_02_14_+1000_9_Z9/AfSi05/vbfg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Fri, 20 Sep 2013 14:35:17 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracl=
e.com> wrote:
>
> > ibft		1 year, 9 months ago
>=20
> Can go away.
>=20
> > swiotlb		11 months ago
>=20
> Need it. Don't remove it pls.
>=20
> > tmem		11 months ago
>=20
> Can go away.

OK, 2 removed.  Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Sep_2013_10_02_14_+1000_9_Z9/AfSi05/vbfg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP4ULAAoJEECxmPOUX5FEHE8P/1dVVaDp48rrL6gj2GSkahrQ
ZtzzJ1lMfw8u7j7F1DmX7vdVeiOAwJJ6IMmlROhxngfOaV3d2VnRvs4dLN4HZezP
1dngxW7APEwhoMsOoof7T8m+elAn0qvU+5BZ+XIw0jpRmGqOo70xhxuuZyT3by32
K1osB79dLVr55NT28TVnFT11ykFTvvV0JRm0n8Zd94D2xqW4YvpUaXkdaKjGLCyA
1j8LFULrlqRKUkfIrieEUdWyp0wKM+tWEbwvncqcqgPUK+5Z0qLpRGa/XpQW2N2y
J6aKmpW5xCYcxfRd67IOqSNW9i4kMWISsP8cddrKR3EQ6xT1JJWFj/N31vaGJnJa
Y3QJKS2ui20/6VRO8WrTaR4QJpOENfdZUb7rZRDZxzsSlumvEiAvsKOE4RvOpr/T
9mZB0oGt2n3OKPDwOvI1ApRc/FPk7smfBFi2OsPNoSEoQQHpt7M9aGC5uAohvOAW
Q7DHKBmUPClidzHAjVLeq1BXkPji3PAv966CLBSlfM5euPgEZiDZk7WKEsM0wr2d
/7YJmHnaaLsjd9WuA0L2pKiYhbfzxMAfO6XxTEh4qMsZENDhxi3/7o+serD5wE8w
ZulGD4CMntgGjz0Px/x4YP2PLZqxlzu946nwLgpLTnUvvKrbMSXZqx3KPuT87sX8
ri7h+6g5vxpWZ+/D+SE5
=5dK4
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_10_02_14_+1000_9_Z9/AfSi05/vbfg--
