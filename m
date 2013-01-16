Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab3APBJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:09:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58007 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757147Ab3APBJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:09:07 -0500
Message-ID: <1358298537.15692.101.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 19/49] NFSv4: Add ACCESS operation to OPEN compound
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 16 Jan 2013 01:08:57 +0000
In-Reply-To: <20130115184244.GB3408@herton-Z68MA-D2H-B3>
References: <20130113174255.736888844@decadent.org.uk>
	 <20130113174259.796403049@decadent.org.uk>
	 <20130115184244.GB3408@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-i+dfkILgY5mRQGZ5flLn"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i+dfkILgY5mRQGZ5flLn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-15 at 16:42 -0200, Herton Ronaldo Krzesinski wrote:
> On Sun, Jan 13, 2013 at 05:43:14PM +0000, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Weston Andros Adamson <dros@netapp.com>
> >=20
> > commit 6168f62cbde8dcf4f58255794efbcdb8df603959 upstream.
> >=20
> > The OPEN operation has no way to differentiate an open for read and an
> > open for execution - both look like read to the server. This allowed
> > users to read files that didn't have READ access but did have EXEC acce=
ss,
> > which is obviously wrong.
> >=20
> > This patch adds an ACCESS call to the OPEN compound to handle the
> > difference between OPENs for reading and execution.  Since we're going
> > through the trouble of calling ACCESS, we check all possible access bit=
s
> > and cache the results hopefully avoiding an ACCESS call in the future.
> >=20
> > Signed-off-by: Weston Andros Adamson <dros@netapp.com>
> > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > [bwh: Backported to 3.2:
> >  - Adjust context
> >  - #include <linux/export.h> in fs/nfs/dir.c]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>=20
> This 3.2 series lacks commit ae2bb03236fc978bdf673c19d39832500793b83c
> pointed in its changelog as fixing a regression from this one.

Thanks.  Actually I'm not at all confident about the adjustments to
these NFSv4 access changes, so I'll drop them all for now.

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.

--=-i+dfkILgY5mRQGZ5flLn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPX9qee/yOyVhhEJAQoVuw//aSHmLDirZalVKRo/mETEN+BSDZJhtrxF
UdGFRmoeQ7w022D3xLkJKxLQsCm55nqbqCZRRaWxSblG6PTfVdupoheW6VsVVYHS
VEIeQCkPDjv0vfasWaPr7h7Mf2miNjK/rAAZVz/OwLThVg0NPWXFofPoWHuJxXgI
Xdr0xDUoY9xRhdxANHvpFJ6yHzzQNkBZgv6CW82S46nUpW0diK3FQ1YL6CYT6qml
3Nr7XcLg6dr3SVbUkPjzvTnnDrUWaqjmVlB3ofJS94fJSY6/1ip/d9iyjTbRKbTl
H3G/7nBLB7vhsWl9jAVwfb585xe8SHCRsJelhfb+W9GCqJUcDrrou8oNqvRsAQUk
r6eDN8O4VSgJMb+MUPfitaMJFRjZCe/VXOf/k0Wte8i34K0aVpyXfZtpXcpSdyTi
MKTVYmtFyy+GoXjtyHyxwiKbJzi8yMHy6b5+GKb5BacJjKCOmxAns/nzOhZhNs5E
TBqK79gPNE5kNJZTaHzhBiBdV73f/styPFnAsY0mqKQHN61Wi5UPRHBe9DxTzW1F
QmHVA4nDuD51rNof/excuzo3r4lOHTT3ncN752UsSj+EgRR8Fc4Ec8hvDEa0MnO6
zFoKBJ7BtCHiUQa/JwrO81EPPiXKXQ8ZccT8B5pWuuBF0WLNTKTqkM5k3XIaI3x/
rMSQxwlQ3Dk=
=LS60
-----END PGP SIGNATURE-----

--=-i+dfkILgY5mRQGZ5flLn--
