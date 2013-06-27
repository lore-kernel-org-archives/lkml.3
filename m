Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3F0HEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:04:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57616 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3F0HEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:04:46 -0400
Date: Thu, 27 Jun 2013 10:04:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <balbi@ti.com>, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: regression caused by commit
 8357b48549e17b3e4e402c7f977b65708922e60f
Message-ID: <20130627070424.GM15455@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130627061419.GE15455@arwen.pp.htv.fi>
 <20130627163655.239cea102ba0eb968a434593@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wAI/bQb0EMvlZCHl"
Content-Disposition: inline
In-Reply-To: <20130627163655.239cea102ba0eb968a434593@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wAI/bQb0EMvlZCHl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2013 at 04:36:55PM +1000, Stephen Rothwell wrote:
> Hi,
>=20
> On Thu, 27 Jun 2013 09:14:19 +0300 Felipe Balbi <balbi@ti.com> wrote:
> >
> > after commit 8357b48549e17b3e4e402c7f977b65708922e60f,
> > omap2plus_defconfig doesn't 'hold' the answer to USB Gadget Drivers
> > anymore. Everytime I run oldconfig, it asks me again and again what USB
> > Gadget Drivers should be (M/y/?).
> >=20
> > That's certainly not expected considering it wasn't like that before.
>=20
> That commit has been reverted in today's kbuild tree and thus in today's
> linux-next.

thanks, I should fetch again :-)

--=20
balbi

--wAI/bQb0EMvlZCHl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy+P4AAoJEIaOsuA1yqREeOwP/0bSlFg87OjCrpnOfJvLr0Ua
VVDgNPZQMbr4oSi5WVkkZljGTVnqIEm+/4XcFvXU7fPZdDvKbErIzbHdg8sg+GMC
d3iPVaoY08lkY/iNXZgNJ9SqJZYu4qLigaUlo6jdH0tz0YTPz1MvsFDSJf9pXdUs
ULj2tCsOAO+zh4pwC6QexSpM7IKRqC8peNcogABAQV21ccz6QfBgF/y4bcwASctf
2QiNmieg/P5W8jH1uM1rMNXETlmYTlyYoMnTtiLpqvLkx9H01VUKtfkP2a0fWWfd
Lzgt5dxPKdZcrXZTfy2O/ApwxSSn3XQ7sjL2XXNkUWQLuWV8b2ZLr8d3i1eEug7L
e6KMkmpM/GAsw1vsWBoahJrw7idhFMgQdUVO8iP3riMXd2BnHgrL5WycfUsgDmkj
1ybGmYYsIO667I+1gGpKvZwtsYREMDy42gcgiaFSeCl/X+nP7UTvgBj8KW43MvX2
MeNDxIApI8/o9k6rjZCE/b1xWU1dDb8bjouMpsNK+OcOkjUxrIUBMqoQAy7xx6bc
0jw+eX+KZ/cjNujYay1B+oD7sOqQ4uqcx5tQzBzDC1d8HsXlv3qr44mTNWQbZEEJ
PRLv3quNBamYf2wfIIrhe/AgRM9tBwvGU2sLotVQBrOmlg32g7p640b1gWlCh7Hh
+AuM4b8Mgn3pCnccbdJj
=un8b
-----END PGP SIGNATURE-----

--wAI/bQb0EMvlZCHl--
