Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaIHO6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:58:00 -0400
Received: from ozlabs.org ([103.22.144.67]:42634 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaIHO56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:57:58 -0400
Date: Tue, 9 Sep 2014 00:57:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Peter Foley <pefoley2@pefoley.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
Message-ID: <20140909005748.53ae038d@canb.auug.org.au>
In-Reply-To: <20140908102229.GG4015@sirena.org.uk>
References: <540651B3.8030400@infradead.org>
	<20140902232906.GG29327@sirena.org.uk>
	<CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com>
	<20140903232149.GG29327@sirena.org.uk>
	<5407A68F.5090805@infradead.org>
	<20140904104201.GI29327@sirena.org.uk>
	<540A503D.20807@infradead.org>
	<540C9D19.5080201@infradead.org>
	<20140907184837.GD4015@sirena.org.uk>
	<20140908180327.6ef7f2b8@canb.auug.org.au>
	<20140908102229.GG4015@sirena.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/iHZ+gmBCUn.ZxY=S8dTTwVK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iHZ+gmBCUn.ZxY=S8dTTwVK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, 8 Sep 2014 11:22:29 +0100 Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Sep 08, 2014 at 06:03:27PM +1000, Stephen Rothwell wrote:
> > On Sun, 7 Sep 2014 19:48:37 +0100 Mark Brown <broonie@kernel.org> wrote:
>=20
> > > Yes, I'm using his scripts.  I guess it's possible there's something =
in
> > > his global git configuration that changes the behaviour?
>=20
> > You seem to have been using an older version of my scripts.  The above
> > was changed on May 5th in commit
> > 9f1441da46c87531635fe742016124db2069db24 in my "tools" directory.
>=20
> Huh, weird.  I rsynced a fresh copy over when I started (and I needed to
> reconfigure where the builds would run and so on so that does seem to
> have worked) so I'm not sure what was going on there...

I just checked and the working tree in the rsync repository is well out
of date with the actual git files :-( sorry about that.  I update that
area by doing a bare git push into the .git directory and (clearly)
don't then reset the working tree.  :-(

That would explain why your etc/control file was missing some trees as
well ...

I will fix that up for next time.

Thanks again for covering for me.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/iHZ+gmBCUn.ZxY=S8dTTwVK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDcPyAAoJEMDTa8Ir7ZwVPC4QAJJoY5TWF+CcT+c9IgkaKJ/J
K9uBmI+hpaP34RjAeSt/jqzSxmUeMHk9q+GPclooL4jExMDgybv4244/91iIqRWa
9UbDVG8qXCWfZZfEq1/9lbmmCnGFP4rMOAXzrgOT6rbuxSD96imlWgx+Iw0uGNus
G8AqL5LlZ6UIDnjcQk/hpnE4KUiZgDEryVrzaL3NMwIm04M6wOHf4GIZZDQEOBKE
QM/mQqbuNhsylUcA/W1qdIwlHi6Urb0yVBBc4joe5lL+LIdp8QY5jOKAvYEK84jB
GLVIKgBAR0KBLj/PLjAP2d5C161CqCVKVg5aobTNQb0+rwTpg0WsrexJeOJBLgP2
2SsxruPkk77DPLYr0NRo14pmmxUyRXkQYy1z54VOx+E4ywMtqhP8MKyepS5eVf/M
ApRhCv8Irger6JINVl/ZdJQ7D/QeawR2FW158twTMg15L1isa2PvnzDBFosxRbi+
qC9JKHPcZWFuRR9CxT6bPGQUl2f4z48zFGM3XgtcZ0usv6ScyLtxvDB45+3VpJKP
mLB1bEYz1wca/ITinDh5m2DW5RNLamBkn0S71n0b9mppr1erkNvO5RclAL3upI2/
xBBfbuawDa1y2RTN/wuS0dpQzDK7pelV79SEpk0FHu/C40fp04kyvqenFlNfiQvN
qJkmnh9EGjCeOOYaCrsi
=AzJc
-----END PGP SIGNATURE-----

--Sig_/iHZ+gmBCUn.ZxY=S8dTTwVK--
