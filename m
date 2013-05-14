Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3ENMuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:50:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48330 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab3ENMuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:50:13 -0400
Date: Tue, 14 May 2013 15:49:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dave Young <dyoung@redhat.com>
CC: Felipe Balbi <balbi@ti.com>, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
Message-ID: <20130514124947.GD21107@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <148688218.8139723.1367911491024.JavaMail.root@redhat.com>
 <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
 <20130509102949.GA28545@darkstar.nay.redhat.com>
 <20130509145044.GG28325@arwen.pp.htv.fi>
 <20130510015058.GA10269@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Content-Disposition: inline
In-Reply-To: <20130510015058.GA10269@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 10, 2013 at 09:51:00AM +0800, Dave Young wrote:
> On Thu, May 09, 2013 at 05:53:08PM +0300, Felipe Balbi wrote:
> > On Thu, May 09, 2013 at 06:29:51PM +0800, Dave Young wrote:
> > > On Tue, May 07, 2013 at 03:25:58AM -0400, CAI Qian wrote:
> > > > Never saw any of those messages were floating in any of the RC test=
ing, but
> > > > now happened in 3.9 GA on Power 7 systems.
> > > >=20
> > > > [    0.329753] EEH: devices created
> > > > [    0.340203] atomic64 test passed
> > > > [    0.340407] NET: Registered protocol family 16
> > > > [    0.340457] EEH: No capable adapters found
> > > > [    0.340609] IBM eBus Device Driver
> > > > [    0.358825] Write permission without 'store'
> > > > [    0.358852] ------------[ cut here ]------------
> > > > [    0.358859] WARNING: at drivers/base/core.c:575
> > > > [    0.358866] Modules linked in:
> > > > [    0.358877] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0+ #1
> > > > [    0.358887] task: c0000003f8bc0000 ti: c0000003f8c00000 task.ti:=
 c0000003f8c00000
> > > > [    0.358897] NIP: c0000000004a7f44 LR: c0000000004a7f40 CTR: 0000=
000001766760
> > > > [    0.358906] REGS: c0000003f8c03780 TRAP: 0700   Not tainted  (3.=
9.0+)
> > > > [    0.358914] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28139=
d24  XER: 00000001
> > > > [    0.358939] SOFTE: 1
> > > > [    0.358944] CFAR: c00000000074427c
> > > > [    0.358950]=20
> > > > GPR00: c0000000004a7f40 c0000003f8c03a00 c000000001117e50 000000000=
0000020=20
> > > > GPR04: 0000000000000000 0000000000000000 00000000160c9615 000000000=
0000000=20
> > > > GPR08: c000000001064af0 0000000000000000 0000000000000000 000000000=
0003fef=20
> > > > GPR12: 0000000028139d22 c000000007f00000 c00000000000bb30 000000000=
0000000=20
> > > > GPR16: 0000000000000000 0000000000000000 c000000000ff1c78 000000000=
0000001=20
> > > > GPR20: 0000000000000000 0000000000000000 0000000000000000 c00000000=
117eb08=20
> > > > GPR24: 00000000000000a6 c000000000af0028 0000000000000000 c00000000=
0ff21a0=20
> > > > GPR28: 0000000000000002 c000000001500030 c0000000011b8200 c00000000=
1500030=20
> > > > [    0.359070] NIP [c0000000004a7f44] .device_create_file+0xa4/0xe0
> > > > [    0.359080] LR [c0000000004a7f40] .device_create_file+0xa0/0xe0
> > > > [    0.359088] Call Trace:
> > > > [    0.359095] [c0000003f8c03a00] [c0000000004a7f40] .device_create=
_file+0xa0/0xe0 (unreliable)
> > > > [    0.359112] [c0000003f8c03a90] [c00000000074daf8] .register_cpu_=
online+0x21c/0x284
> > > > [    0.359126] [c0000003f8c03b30] [c000000000a78308] .topology_init=
+0x130/0x200
> > > > [    0.359138] [c0000003f8c03c10] [c00000000000b4d4] .do_one_initca=
ll+0x144/0x1f0
> > > > [    0.359150] [c0000003f8c03cd0] [c000000000a746a8] .kernel_init_f=
reeable+0x23c/0x32c
> > > > [    0.359163] [c0000003f8c03db0] [c00000000000bb4c] .kernel_init+0=
x1c/0x130
> > > > [    0.359175] [c0000003f8c03e30] [c00000000000a164] .ret_from_kern=
el_thread+0x64/0x80
> > > > [    0.359184] Instruction dump:
> > > > [    0.359190] 3863e610 4829c2f1 60000000 0fe00000 e8810070 4bffffb=
0 60000000 3c62ff8c=20
> > > > [    0.359211] f8810070 3863e5e8 4829c2cd 60000000 <0fe00000> e8810=
070 a1240008 4bffff80=20
> > > > [    0.359241] ---[ end trace c949de754c984735 ]---
> > > >=20
> > > Hi, Caiqian
> > >=20
> > > Could you try below debug patch to print the attr name?
> > >=20
> > > ---
> > > print the sysfs attribute file name when we warn about bogus permissi=
ons=20
> > >=20
> > > Make it obvious to see what attribute is using bogus permissions.
> > >=20
> > > Signed-off-by: Dave Young <dyoung@redhat.com>
> > > ---
> > >  drivers/base/core.c |    6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >=20
> > > --- linux-2.6.orig/drivers/base/core.c
> > > +++ linux-2.6/drivers/base/core.c
> > > @@ -572,9 +572,11 @@ int device_create_file(struct device *de
> > > =20
> > >  	if (dev) {
> > >  		WARN(((attr->attr.mode & S_IWUGO) && !attr->store),
> > > -				"Write permission without 'store'\n");
> > > +			"Attribute "%s": write permission without 'store'\n",
> >=20
> > sure this even builds ?
> >=20
>=20
> Hi, Felipe
>=20
> Oops, here is the fix:
> ---
>=20
> print the sysfs attribute file name when we warn about bogus permissions=
=20
>=20
> Make it obvious to see what attribute is using bogus permissions.
>=20
> [v1->v2] build fix
>=20
> Signed-off-by: Dave Young <dyoung@redhat.com>

looks alright to me:

Acked-by: Felipe Balbi <balbi@ti.com>

But you need to resend as a proper patch so Greg can apply. Also, the
v1->v2 note shoudln't be in the commit log area.

cheers

> ---
>  drivers/base/core.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> --- linux-2.6.orig/drivers/base/core.c
> +++ linux-2.6/drivers/base/core.c
> @@ -572,9 +572,11 @@ int device_create_file(struct device *de
> =20
>  	if (dev) {
>  		WARN(((attr->attr.mode & S_IWUGO) && !attr->store),
> -				"Write permission without 'store'\n");
> +			"Attribute %s: write permission without 'store'\n",
> +			attr->attr.name);
>  		WARN(((attr->attr.mode & S_IRUGO) && !attr->show),
> -				"Read permission without 'show'\n");
> +			"Attribute %s: Read permission without 'show'\n",
> +			attr->attr.name);
>  		error =3D sysfs_create_file(&dev->kobj, &attr->attr);
>  	}
> =20
>=20

--=20
balbi

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRkjLrAAoJEIaOsuA1yqRElPEP/2V3XjAGU7l/DWWpj8Uxe4HJ
z8GlXkIBi2F9rGU/E9+xbKl9M/FbBeewgxSWp0Ne9zI8ReQMTl3YnYBLMAiwJ9Jn
b8dWhr1DdEL4MvPoL+ERbR5GgbeA6AGkq5CbAR81hpnOdyXRwEOaB7Ud7LcJQCT+
gA/uXISzodOAVIPIiLFnqksk+XpBYujCnJrDWrjJ/PB39lQqiPO3llFq8M8POFUz
Xdeb2KVBbQGhYXWVxpMPOCpR8ZHPB5maR+wxqaAtXjmL7SNqY6YFxioe3TvHs5+v
NiIGH8WbKd+0geHP7VqtvKiwXAFNvSMaHFNxM4NdGifvHr1MdR5vO0uDqwdhszG1
htEjBzrOVXhh6vkR6rxu91vS0xHD4LDfqVEzhFXQ2cS+0acGncIBLKDjgn/QCDnH
0Taqm6aLJ6frEA0mhfIMQ6qQBf2kOqrVAHUMkiw1zhUOgRXtk/TyrMVQaqh3UooV
5cqDm/50Bn+EFGDK4KAbdFLkDbQV+mX4gDD4+ZYvDsUC14NLjImYtFxzSkZQBTHE
5p8pJY8stPHTYhJTx5HiiTSAseLRHM6dFBO8jAbm6xN+/x/WV5T/I8AV1GFI9mVG
1Nmjk4M9pChQFWwFkMGkzvo9hvs5LcEvjW6k4/CY6mhgso8xOhE+B37BubwY7get
T14Kq9IH7FXBVPfvqN3z
=wrfg
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
