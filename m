Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab3K0UM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:12:56 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53522 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab3K0UMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:12:55 -0500
Date: Wed, 27 Nov 2013 14:11:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Felipe Balbi <balbi@ti.com>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 00/13] mfd: menelaus: a few cleanups
Message-ID: <20131127201149.GB20734@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385579217-20127-1-git-send-email-balbi@ti.com>
 <20131127200247.GH24645@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <20131127200247.GH24645@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 27, 2013 at 10:02:47PM +0200, Aaro Koskinen wrote:
> On Wed, Nov 27, 2013 at 01:06:44PM -0600, Felipe Balbi wrote:
> > few cleanups on the old menelaus driver. I don't have
> > HW to test these patches, maybe Aaro can help here ?
>=20
> Hmm, I got:
>=20
> [    1.330000] Unable to handle kernel NULL pointer dereference at virtua=
l address 00000000
> [    1.340000] pgd =3D c0004000
> [    1.340000] [00000000] *pgd=3D00000000
> [    1.350000] Internal error: Oops: 17 [#1] ARM
> [    1.350000] CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-rc1-n8x0_ti=
ny-los.git-729021f-00018-g74a0f39 #2
> [    1.350000] task: c782c000 ti: c782e000 task.ti: c782e000
> [    1.350000] PC is at mutex_lock+0x0/0x20
> [    1.350000] LR is at __irq_get_desc_lock+0x6c/0x88
> [    1.350000] pc : [<c016745c>]    lr : [<c00509ac>]    psr: a0000013
> [    1.350000] sp : c782fe10  ip : fffffffa  fp : 00000000
> [    1.350000] r10: c01e0268  r9 : 00000000  r8 : c7903e20
> [    1.350000] r7 : 00000001  r6 : c782fe2c  r5 : 00000000  r4 : c7147080
> [    1.350000] r3 : c013eab0  r2 : 00000000  r1 : 000000f2  r0 : 00000000
> [    1.350000] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segme=
nt kernel
> [    1.350000] Control: 00c5387d  Table: 8704c000  DAC: 00000017
> [    1.350000] Process swapper (pid: 1, stack limit =3D 0xc782e1b8)
> [    1.350000] Stack: (0xc782fe10 to 0xc7830000)
> [    1.350000] fe00:                                     00000000 000000f=
2 c0053034 00000000
> [    1.350000] fe20: 00000000 c0053518 c016b798 00000000 000000f2 c711ea1=
0 00000102 c7903e00
> [    1.350000] fe20: 00000000 c0053518 c016b798 00000000 000000f2 c711ea1=
0 00000102 c7903e00
> [    1.350000] fe40: c7903e20 c013ec80 c016b798 c711ea10 c7903e20 c013ebc=
4 c7903e00 00000000
> [    1.350000] fe60: c046ae74 00000000 00000015 c0140ab8 c7903e20 c0498b1=
0 c0498b18 c0131194
> [    1.350000] fe80: c7903e20 c046ae74 c7903e54 00000000 c01da8fc c013133=
8 00000000 c046ae74
> [    1.350000] fea0: c01312ac c012fa00 c784e64c c78e7f90 c046ae74 c70b642=
0 c046b1e0 c01301a8
> [    1.350000] fec0: c01b1130 c00ce2fc c046ae74 c046ae74 c01dce14 c01e24d=
0 c01c6484 c01316cc
> [    1.350000] fee0: c046b1e0 c046ae50 c01dce14 c0141bc8 c782e000 0000000=
6 c01dce14 c01c6ad0
> [    1.350000] ff00: c04907e4 c784d3c0 c016b7a8 0000006f 00000000 0000000=
0 00000000 c00c488c
> [    1.350000] ff20: c05998c0 c0170258 00000015 c003ff84 c0466030 0000000=
0 c01b1204 c01b4358
> [    1.350000] ff40: 00000006 00000006 00000000 00000006 00000006 c01dce1=
4 c01e24d0 c01c6484
> [    1.350000] ff60: c01dce20 c046c460 00000015 c01c6c70 00000006 0000000=
6 c01c6484 ffffffff
> [    1.350000] ff80: ffffffff ffffffff 00000000 c01634e0 00000000 0000000=
0 00000000 00000000
> [    1.350000] ffa0: 00000000 c01634e8 00000000 c000e0f8 00000000 0000000=
0 00000000 00000000
> [    1.350000] ffc0: 00000000 00000000 00000000 00000000 00000000 0000000=
0 00000000 00000000
> [    1.350000] ffe0: 00000000 00000000 00000000 00000000 00000013 0000000=
0 ffffffff ffffffff
> [    1.350000] [<c016745c>] (mutex_lock+0x0/0x20) from [<c00509ac>] (__ir=
q_get_desc_lock+0x6c/0x88)
> [    1.350000] [<c00509ac>] (__irq_get_desc_lock+0x6c/0x88) from [<c00535=
18>] (__irq_set_handler+0x24/0x128)
> [    1.350000] [<c0053518>] (__irq_set_handler+0x24/0x128) from [<c013ec8=
0>] (menelaus_probe+0xbc/0x280)
> [    1.350000] [<c013ec80>] (menelaus_probe+0xbc/0x280) from [<c0140ab8>]=
 (i2c_device_probe+0x98/0xc0)
> [    1.350000] [<c0140ab8>] (i2c_device_probe+0x98/0xc0) from [<c0131194>=
] (driver_probe_device+0x110/0x228)
> [    1.350000] [<c0131194>] (driver_probe_device+0x110/0x228) from [<c013=
1338>] (__driver_attach+0x8c/0x90)
> [    1.350000] [<c0131338>] (__driver_attach+0x8c/0x90) from [<c012fa00>]=
 (bus_for_each_dev+0x54/0x88)
> [    1.350000] [<c012fa00>] (bus_for_each_dev+0x54/0x88) from [<c01301a8>=
] (bus_add_driver+0xd4/0x1c8)
> [    1.350000] [<c01301a8>] (bus_add_driver+0xd4/0x1c8) from [<c01316cc>]=
 (driver_register+0x78/0xf4)
> [    1.350000] [<c01316cc>] (driver_register+0x78/0xf4) from [<c0141bc8>]=
 (i2c_register_driver+0x2c/0xb8)
> [    1.350000] [<c0141bc8>] (i2c_register_driver+0x2c/0xb8) from [<c01c6a=
d0>] (do_one_initcall+0x94/0x150)
> [    1.350000] [<c01c6ad0>] (do_one_initcall+0x94/0x150) from [<c01c6c70>=
] (kernel_init_freeable+0xe4/0x1b0)
> [    1.350000] [<c01c6c70>] (kernel_init_freeable+0xe4/0x1b0) from [<c016=
34e8>] (kernel_init+0x8/0x110)
> [    1.350000] [<c01634e8>] (kernel_init+0x8/0x110) from [<c000e0f8>] (re=
t_from_fork+0x14/0x3c)
> [    1.350000] Code: 03a03000 05843000 e28dd010 e8bd81f0 (e1902f9f)
> [    1.360000] ---[ end trace 75cc9e337407e765 ]---
> [    1.360000] Kernel panic - not syncing: Attempted to kill init! exitco=
de=3D0x0000000b

hmm, irq_set_chip_and_handler() will call back into the irq_chip we just
registered, so my ->irq_bus_lock needs to have everything setup
(chip_data my mutex), this should solve it:

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 376f01d..c9bd2fb 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1232,6 +1232,7 @@ static int menelaus_probe(struct i2c_client *client,
=20
 	the_menelaus =3D m;
 	m->client =3D client;
+	mutex_init(&m->lock);
=20
 	irq_base =3D irq_alloc_descs(-1, 0, MENELAUS_NR_IRQS, 0);
 	if (irq_base < 0) {
@@ -1245,10 +1246,10 @@ static int menelaus_probe(struct i2c_client *client,
 	m->irq_base =3D irq_base;
=20
 	for (i =3D irq_base; i < irq_base + MENELAUS_NR_IRQS; i++) {
+		irq_set_chip_data(i, m);
 		irq_set_chip_and_handler(i, &menelaus_irq_chip,
 				handle_simple_irq);
 		irq_set_nested_thread(i, 1);
-		irq_set_chip_data(i, m);
 		set_irq_flags(i, IRQF_VALID);
 	}
=20
@@ -1280,8 +1281,6 @@ static int menelaus_probe(struct i2c_client *client,
 		}
 	}
=20
-	mutex_init(&m->lock);
-
 	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
=20
 	val =3D menelaus_read_reg(m, MENELAUS_VCORE_CTRL1);


let me know when you can, and I'll meld these hunks to proper patch.

--=20
balbi

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSllIFAAoJEIaOsuA1yqREw+sP/j8AUWwP84wU38iZzQdX1lpB
Ub/ZULc52iyk4cSJlFxrsEFI7vJLa9YGl3d6E7AjuYzwJwzwDKaVp8fGDcoKKPTp
MpjfwQTHydosejafcK/ARKAENLMm9faB/pTV3MhTTxVgxI5bHhh41iPwqYriFbTQ
AJOuyrCf8xzOjZN3ZEZpwxmGmojcWgT4TVXWwSJUwoGp9wGOZHATF31kdd9lfCAD
GR0OGxpNtqo+ZgBMW8aU1b3tgLswxd03gL/7/CeIXMVT4I3n7piPMrAv8c9mMUHU
TX9lPwK93phVTYW5JU42QG5+XmgdgttI8vbUkEML2P4hZZcvDyO0ARWZDUOA+4Hn
TK7t5nEezgkpAy3XtJ6V4LCqL5NJc8auDVwm/uGCWhY8bxPDhKP8vGvT/S2xVTOI
0aoNd23AHbBBUAcuicK4REdXDzM9FK7b8Tl4FCM/roknyGHm+TjHY6p25YDaHUJo
vH2ntWNgTrTAAogZNOnB3JR8ntI04XEyyrlSOEiFRESDFDWKkxu9uWIlHMb7ZaGW
cYJoOf2i/wwSFKBT/tIdJVqWFbGKcswjMqMMVHdu8rUbfNzOTqmzHwTmnnPonxs+
0LUOlFkUPzRUBgOFDuK57pmggmapJIBwV6uFxLN5CdW8AbuNXRPe/bizYmW1tT4V
5oD1hT6dLYcrfaF/ZShA
=xtn2
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
