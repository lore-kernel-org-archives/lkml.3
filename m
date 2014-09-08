Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaIHIDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:03:44 -0400
Received: from ozlabs.org ([103.22.144.67]:43721 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbaIHIDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:03:42 -0400
Date: Mon, 8 Sep 2014 18:03:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Peter Foley <pefoley2@pefoley.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
Message-ID: <20140908180327.6ef7f2b8@canb.auug.org.au>
In-Reply-To: <20140907184837.GD4015@sirena.org.uk>
References: <53FB9DA0.7000301@infradead.org>
	<CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
	<540651B3.8030400@infradead.org>
	<20140902232906.GG29327@sirena.org.uk>
	<CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com>
	<20140903232149.GG29327@sirena.org.uk>
	<5407A68F.5090805@infradead.org>
	<20140904104201.GI29327@sirena.org.uk>
	<540A503D.20807@infradead.org>
	<540C9D19.5080201@infradead.org>
	<20140907184837.GD4015@sirena.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/IbUJydwLY1td9P7A=SwEPeY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IbUJydwLY1td9P7A=SwEPeY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Sun, 7 Sep 2014 19:48:37 +0100 Mark Brown <broonie@kernel.org> wrote:
>
> On Sun, Sep 07, 2014 at 10:59:53AM -0700, Randy Dunlap wrote:
>=20
> > The quilt-import.log from 20140829 says:
>=20
> > $ git am --patch-format=3Dmbox ../quilt/rd-docs/001-docum-use-subdiry-a=
void-builtin.patch
>=20
> > and in the 20140905 git tree it says:
>=20
> > $ git am ../quilt/rd-docs/001-docum-use-subdiry-avoid-builtin.patch
> > Patch format detection failed.
>=20
> > Are you using Stephen's scripts?  Why would his tree apply patches with
> > --patch-format=3Dmbox
> > while the later trees did not use that git-am option?
>=20
> Yes, I'm using his scripts.  I guess it's possible there's something in
> his global git configuration that changes the behaviour?


You seem to have been using an older version of my scripts.  The above
was changed on May 5th in commit
9f1441da46c87531635fe742016124db2069db24 in my "tools" directory.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/IbUJydwLY1td9P7A=SwEPeY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDWLUAAoJEMDTa8Ir7ZwVL1MP/3eFLo8w84vblR5pzjeQslKt
M/5CueQL0GHzJ8xmpYyqfkxsGFPYcHovjkihkhhQDesN/V2IOlw7+PSioyR/8NuP
D2cdjLeCb1d4CwpK8B1Vxy3BR99YIFaVEu3Hp7DBW86qiviesMZgvxdPkYFMxB34
/xmSqKldYGCgjV9jOwOnsImo9rye8RRplFwjOq3i2YttKDSDh7ZvhMRbaCEJrDs+
COQKFM4+1gOpmd+nGP6DsyrHvSyxTmtOWppiUfCLulfC+bDB8pzvnT5yTIWU9Qly
2ttLTBFyTUKqGKWxt0mI/O6WpvK2Qr3kXrY/+hOePr6yxxyAjZFjHtjFQsTyFilk
9sC8CRsQRFPhYd74O9RkReZnCLQiJIs1DiwOwQ2hvBd9lwqMGDqfC1P8XReUwiRH
HZk35H16/WOm4W0f2gwz7cNDus+55x7yfbj11SKPGpIrikE8BkakzVj4cR5Yn6oQ
jxDFDhxRUO6FYxB2SkcNY1b84GLuOn+7ACZhqyjHY7vCeykvKUBMgWie+GBvZ5jh
FhxdXXD1El5hNggtQ/LpL73+/F+Q7tKsmyAVcZzv8jUHFia/ORRxFRx7c8WAfvJv
tvGFTCboDYnWQyar0sDAVO53nQAwg6T8NxrsDVihaFf+0HmpfopCuDYfPY74BZVK
XsTtdXtDiEqPpeeZ0MUq
=so86
-----END PGP SIGNATURE-----

--Sig_/IbUJydwLY1td9P7A=SwEPeY--
