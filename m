Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbaGUPMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:12:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46245 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511AbaGUPMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:12:31 -0400
Date: Mon, 21 Jul 2014 10:11:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <balbi@ti.com>, Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 0/9] usb: musb: several bugfixes for the musb driver
Message-ID: <20140721151140.GG6852@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <20140718161636.GA18460@arch.cereza>
 <20140718165044.GA30821@saruman.home>
 <20140721093430.3f528cc7@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+1TulI7fc0PCHNy3"
Content-Disposition: inline
In-Reply-To: <20140721093430.3f528cc7@ipc1.ka-ro>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+1TulI7fc0PCHNy3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 09:34:30AM +0200, Lothar Wa=DFmann wrote:
> Hi,
>=20
> Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Jul 18, 2014 at 01:16:36PM -0300, Ezequiel Garcia wrote:
> > > Hi Lothar,
> > >=20
> > > On 18 Jul 11:31 AM, Lothar Wa=DFmann wrote:
> > > > The first three patches do some source code cleanup in the files th=
at
> > > > are modified in the subsequent patches.
> > > >=20
> > >=20
> > > I've applied patches 4 and 9 on a recent -next, after fixing a confli=
ct
> > > due to patch 3 ("usb: musb_am335x: source cleanup"):
> > >=20
> > > > Patch 4 carries the proper fix reported in commit:
> > > >         7adb5c876e9c ("usb: musb: Fix panic upon musb_am335x module=
 removal")
> > > >=20
> > > > Patch 9 reinstates module unloading support for the musb_am335x dri=
ver
> > > >         which was disabled due to a false failure analysis
> > > >=20
> > >=20
> > > For these two patches, Tested-by: Ezequiel Garcia <ezequiel@vanguardi=
asur.com.ar>
> > >=20
> > > Tested on a beaglebone with a mass storage USB device, module load/un=
load
> > > works without issues. The module_get/put in the phy is now preventing=
 the
> > > musb_am335x driver unload, which seems to be the real cause of the is=
sue
> > > I reported. Thanks for providing a proper fix!
> >=20
> > I don't that's a good fix. The problem is that even after am335x
> > removing all its child, someone else tried to release the PHY. That
> > ordering is the one that needs to be fixed. Doing a module_get on the
> > parent device looks like a hack to me.
> >=20
> No. It guarantees that the module cannot be unloaded when its resources
> are still in use!

it's still a hack. You have a child incrementing the usage count on its
parent just because a sibbling isn't doing the right thing.

--=20
balbi

--+1TulI7fc0PCHNy3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzS2sAAoJEIaOsuA1yqREQh0P/3EJVEfV2T6AQ/xyRNTncXiq
WfxsCRFCKVpo0ahHjV9xGgmc8dwH735zQp7r/dmrOwbT6ns5U6lZo48jvzYHhEkD
Gq6z1viYZES8G+0ryMvESDAFs9zZbvEbxp+ySs3VoQgnAdiQ/Z/pcfUPSlcx0rCV
p83khHgQKYsql3YatlrSuE0DL6z3sCu2OXQnTRfAayIcavQTTUYfHLuubvfy2u47
K0CuViEetjP9VknJwZvA3Ar+QbarPFgkAYJ6h8B7J9LUDaewehSAY/4R+a95ex/5
MMMaGMxS2cGlFxsJxxe5J3mZ8vbAt6aMTtUGv0ZgUEkdQ+v/m1P3V7h3VEKKywJh
AvkKZq0lM2fHjDQ4YajMSJ61z7wda6FxO8m8zrsvZ7+5L0Hq+VmtmevDwe3nCmOB
Hi74S/xV8wCLVmuP31pBd5EyVNMnIsUTKm+wCNOoIR2N6dQtFgoqn9tVibk7m2ja
pEKBf96QQZFYSAttBmI42Mmm2kRvUe+fNrl0ZG1+aGJoe7E8KqrYjEQoD+nsGJG2
3+50L9dBAnV4Y9SZGK//W0HKNcLnTmiNemQD/0x2XBGxN/PS2YtxXy3xjQm8JYA/
SMU5u2rLG3Tp00jH75T936t7kOkaxJVT48puh/jIjOncpATS+aVZYwtLnSxK5g2C
44PZAXlguZP3PMM5zoC7
=OWcF
-----END PGP SIGNATURE-----

--+1TulI7fc0PCHNy3--
