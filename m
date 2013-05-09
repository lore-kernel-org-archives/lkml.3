Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3EIOx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:53:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52551 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3EIOxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:53:21 -0400
Date: Thu, 9 May 2013 17:53:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dave Young <dyoung@redhat.com>
CC: CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
Message-ID: <20130509145044.GG28325@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <148688218.8139723.1367911491024.JavaMail.root@redhat.com>
 <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
 <20130509102949.GA28545@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CD/aTaZybdUisKIc"
Content-Disposition: inline
In-Reply-To: <20130509102949.GA28545@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CD/aTaZybdUisKIc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 09, 2013 at 06:29:51PM +0800, Dave Young wrote:
> On Tue, May 07, 2013 at 03:25:58AM -0400, CAI Qian wrote:
> > Never saw any of those messages were floating in any of the RC testing,=
 but
> > now happened in 3.9 GA on Power 7 systems.
> >=20
> > [    0.329753] EEH: devices created
> > [    0.340203] atomic64 test passed
> > [    0.340407] NET: Registered protocol family 16
> > [    0.340457] EEH: No capable adapters found
> > [    0.340609] IBM eBus Device Driver
> > [    0.358825] Write permission without 'store'
> > [    0.358852] ------------[ cut here ]------------
> > [    0.358859] WARNING: at drivers/base/core.c:575
> > [    0.358866] Modules linked in:
> > [    0.358877] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0+ #1
> > [    0.358887] task: c0000003f8bc0000 ti: c0000003f8c00000 task.ti: c00=
00003f8c00000
> > [    0.358897] NIP: c0000000004a7f44 LR: c0000000004a7f40 CTR: 00000000=
01766760
> > [    0.358906] REGS: c0000003f8c03780 TRAP: 0700   Not tainted  (3.9.0+)
> > [    0.358914] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28139d24 =
 XER: 00000001
> > [    0.358939] SOFTE: 1
> > [    0.358944] CFAR: c00000000074427c
> > [    0.358950]=20
> > GPR00: c0000000004a7f40 c0000003f8c03a00 c000000001117e50 0000000000000=
020=20
> > GPR04: 0000000000000000 0000000000000000 00000000160c9615 0000000000000=
000=20
> > GPR08: c000000001064af0 0000000000000000 0000000000000000 0000000000003=
fef=20
> > GPR12: 0000000028139d22 c000000007f00000 c00000000000bb30 0000000000000=
000=20
> > GPR16: 0000000000000000 0000000000000000 c000000000ff1c78 0000000000000=
001=20
> > GPR20: 0000000000000000 0000000000000000 0000000000000000 c00000000117e=
b08=20
> > GPR24: 00000000000000a6 c000000000af0028 0000000000000000 c000000000ff2=
1a0=20
> > GPR28: 0000000000000002 c000000001500030 c0000000011b8200 c000000001500=
030=20
> > [    0.359070] NIP [c0000000004a7f44] .device_create_file+0xa4/0xe0
> > [    0.359080] LR [c0000000004a7f40] .device_create_file+0xa0/0xe0
> > [    0.359088] Call Trace:
> > [    0.359095] [c0000003f8c03a00] [c0000000004a7f40] .device_create_fil=
e+0xa0/0xe0 (unreliable)
> > [    0.359112] [c0000003f8c03a90] [c00000000074daf8] .register_cpu_onli=
ne+0x21c/0x284
> > [    0.359126] [c0000003f8c03b30] [c000000000a78308] .topology_init+0x1=
30/0x200
> > [    0.359138] [c0000003f8c03c10] [c00000000000b4d4] .do_one_initcall+0=
x144/0x1f0
> > [    0.359150] [c0000003f8c03cd0] [c000000000a746a8] .kernel_init_freea=
ble+0x23c/0x32c
> > [    0.359163] [c0000003f8c03db0] [c00000000000bb4c] .kernel_init+0x1c/=
0x130
> > [    0.359175] [c0000003f8c03e30] [c00000000000a164] .ret_from_kernel_t=
hread+0x64/0x80
> > [    0.359184] Instruction dump:
> > [    0.359190] 3863e610 4829c2f1 60000000 0fe00000 e8810070 4bffffb0 60=
000000 3c62ff8c=20
> > [    0.359211] f8810070 3863e5e8 4829c2cd 60000000 <0fe00000> e8810070 =
a1240008 4bffff80=20
> > [    0.359241] ---[ end trace c949de754c984735 ]---
> >=20
> Hi, Caiqian
>=20
> Could you try below debug patch to print the attr name?
>=20
> ---
> print the sysfs attribute file name when we warn about bogus permissions=
=20
>=20
> Make it obvious to see what attribute is using bogus permissions.
>=20
> Signed-off-by: Dave Young <dyoung@redhat.com>
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
> +			"Attribute "%s": write permission without 'store'\n",

sure this even builds ?

--=20
balbi

--CD/aTaZybdUisKIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRi7hUAAoJEIaOsuA1yqREInwP/RbsRkAWsramvqDVRYBvCxLh
CxVALEgD6AqgRZ8UFcmOeYH3kTwjlA+apbCJTZ2emW65k+uB2pLVk1MeMQ0xmn1l
8lHNmJhht14ls4j/lKIP+jT18N7J445dRPkv0MZ65LeDvPtjJGJiQgXH+Y0xaQyR
bTYnt/FKVgMY86gZ859e03/Zceirk/CUlMwGMEdVwASIUd5E+gQcbU2OOPp+E7Jn
VglgpfAFa4TYc5ADNFvSiScC2FqE5Wu0HjR5J3mC549yXJWnAvp7BNAG3mnm11fc
3l+bXt3cL+NGfMwhNjHCCC925On7sNIBFXb5rwYwwLrdjGjwaina/OD0EIDibftx
6LWiw+f2VMEwHchtigrQFMclKGp4FOF8yGduittHwFe5d5ysz3DVGj44Qkq11rmt
mgNI3WComdVmt5eXc4B23BoLnLmOxzXt6sBAPjMV7+gytfoXCN3juKi97GL6KiGf
2oucrwrbb9RDas7UYCpOpxX5HVJngPkxSIKENNmCvzOvAb4uT8022/JW2YQtoCtt
Bi5bnRbBp+PDdyrrHadOwe4y2Nk/fpmayUlbOv9oW73cSlzqPFn5fN73DXjla4P5
w8TtTj5Le/Xtj8cONZOsDGqS0fZUHDk2zXz439m3ZyXNx/5QVDEwe49TKWhyRgAX
4q5wdr+Pps2yV/lv/HNq
=E1c9
-----END PGP SIGNATURE-----

--CD/aTaZybdUisKIc--
