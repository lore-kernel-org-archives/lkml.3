Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab3FRUQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:16:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33155 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab3FRUQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:16:19 -0400
Date: Tue, 18 Jun 2013 23:12:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>,
        David Lopo <dlopo@chipidea.mips.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: linux-next: Tree for Jun 18 usb/chipidea)
Message-ID: <20130618201245.GB14784@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130618173030.16d73801ab72b7c611faccea@canb.auug.org.au>
 <51C0AC74.5050705@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <51C0AC74.5050705@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 11:52:36AM -0700, Randy Dunlap wrote:
> On 06/18/13 00:30, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since 20130617:
> >=20
>=20
>=20
> on i386:
>=20
> # CONFIG_USB_PHY is not set
>=20
> drivers/built-in.o: In function `ci_hdrc_probe':
> core.c:(.text+0x20446b): undefined reference to `of_usb_get_phy_mode'
>=20
>=20
> chipidea needs to depend on or select some kind of USB_PHY support...?

hmm, looks like a missing stub to me. Alex ?

--=20
balbi

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwL89AAoJEIaOsuA1yqREdXAP/2II0v8MzNbMuM29NzDGnTi5
F2LNBk1k7fr4B1plEPMo8VPD4ITIrfaNZKV1WvCTYvy7+zuqGXnFDchyeYnkRvZU
D7z1dHLNaGjJWyAomVNH0GERbq1UcfPEQM728MejR2eMbPaZlG81leBkXkr242/S
mqnZwuSGl9yKE/F3ZlKUwSBIo3i89DgIsKG4XrMTc5gpalANDV8Dn51rLycnn4sh
Ai2GZU1j4tCXnY6Oyw0OzkyfONgPxE+p+yBXhJywSojUVdJKmINZuavpe6x8RXj6
ZaILKnLVm72MmGG19bjyusL5g6jm3dkX5ZTQ6a7rFGXP1AoKcDgaClDPDHCWZMBI
C8Do8x8Q2DHmJh/andiJKvJB4GeRm5gawC0kbgFPDO35bMTUguTyoCoaLg0L4Q7h
afou96Ib5yQgSA4bqioPzRVCUXllCKrDRwmLRmBv95ehDqPYAXxSnuXEpu6ov+U8
bcOkjLbHLjbxyEKF13OUoX+wqaHosAVfUdheDe4BhSLvOVfTRwmMAA8ofPhGgZgh
xDRFeuYTQVl2rb9T96fTB+JhEqOok2NB2DYmkVFdoa9qNEpVvob0931i9RrsPum8
KlFeJjkLoAqNPqPmE8t7pXXYMz4dE4U16SBF8KUJa3RA3c8YackzL9ZW2eu0I7IH
zIP1gAZvRoerzSzN/NxR
=uh9F
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
