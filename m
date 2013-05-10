Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab3EJEjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 00:39:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55723 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706Ab3EJEjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 00:39:04 -0400
Message-ID: <1368160739.17344.16.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.8-stable]  kernel/audit_tree.c: tree will leak memory
 when failure occurs in audit_trim_trees()
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "'Chen Gang'" <gang.chen@asianux.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>
Date: Fri, 10 May 2013 05:38:59 +0100
In-Reply-To: <20130508103611.GB3763@hercules>
References: <007001ce457e$dcfff1c0$96ffd540$%choi@samsung.com>
	 <20130508103611.GB3763@hercules>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Rh/2JiJJDUi5PlnBapyA"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:4022:769e:a966:672f
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Rh/2JiJJDUi5PlnBapyA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-05-08 at 11:36 +0100, Luis Henriques wrote:
> On Tue, Apr 30, 2013 at 05:44:01PM +0900, Jonghwan Choi wrote:
> > This patch looks like it should be in the 3.8-stable tree, should we ap=
ply
> > it?
>=20
> This commit seems to be applicable to other stable trees as well (3.0,
> 3.2, 3.5, ...).
[...]

I've queued this up for 3.2, thanks all.

Ben.

--=20
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison

--=-Rh/2JiJJDUi5PlnBapyA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUYx54+e/yOyVhhEJAQoemg/9GRVdqV6t6YJ98sMbzYehPve4YzTBHRBu
mSrhTnZamoqW4pnUYBU8hQAAy2It7GZyja6Wwinc+xvsKzQYvg5QUFnj3KP7KKTT
+C06qEmgs8GjS3OsXFLGxpqOBOYyfRUGCho5cM2D4pndJ6m4aaEkeTfLs1sRoyZM
Ckvm1a3ple02kmFoOV5o1VpWAsQa2cdT8L4R1eLwRPEW+vrHoEgJ2c+BKgCsIUar
jpyO5oAXT5nnYbxS54JNFllHE9B/bjapHYRn+q3T2KjaferDhRDxZnDONTCsQDpp
H7Qg1vk08JsA3hggy10XX1F/TOC7JpxxtF+/YN49N16A5TXZdOUdAdZMjuXfSxdJ
D4/od1S+sKAE62Gr3LrYsBVXAWci/JUTYii8w03YJfoIr5uf/bfDPnJEzpWwwVr/
ANIKfuiJyYolrGmWakwdHbyg+7u7AGJxCGQU2pJEE2TQnrZGCqUo04d8lR2dtW5o
IzK+b+gtyu3bQY2O7pTLNX+t6Lt+mq+pKV3L89jp1cawzebEB3fM7/pDp64Tu6j3
uqfae3O2NjJdzAXjc6DS9/VmzYFWK0OUh6MJQCoOQ2u+LiQ3sG0h3jIhB2ckqHhO
apJ6H/s3WSY9g1trJWeB22rhOp0pB1HxFaHos7M2NzGq6YilyCdj2MKVTTr9/ctX
ervRCbHf2Zw=
=w7Mo
-----END PGP SIGNATURE-----

--=-Rh/2JiJJDUi5PlnBapyA--
