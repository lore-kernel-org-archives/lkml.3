Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3JWLaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:30:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45534 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752559Ab3JWLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:30:06 -0400
Date: Wed, 23 Oct 2013 12:25:58 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, daniel.lezcano@linaro.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-sunxi@googlegroups.com
Subject: Re: [Add SMP support for Allwinner A20: PATCH V5 0/3]
Message-ID: <20131023112558.GW3041@lukather>
References: <1382027827-10080-1-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YIbTR3mqhHpBjtK1"
Content-Disposition: inline
In-Reply-To: <1382027827-10080-1-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YIbTR3mqhHpBjtK1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2013 at 12:37:04AM +0800, Fan Rong wrote:
> V1 V2:
> The patchs add smp support for Allwinner A20. It add cpuregister node in =
dts for smp configure. The patchs also add a options for phy count timer to=
 replace vir count timer as ARM arch timer clocksource.
> V3 Changes since V2:
> It delete platform.h and delete some code in platsmp.c that's not necessa=
ry. It delete phy count timer support because most linux kernel platform wa=
nt to use vir count timer especially for kvm. SMP need arch timer as clocks=
ource, It does use virtual counter timer and  no longer use physical counte=
r timer, so bootloader ***must*** set CNTVOFF register for a20 before kerne=
l booting. I have add support set CNTVOFF register for uboot, if you want t=
o test it in a20 board, you need update your sunxi uboot from: https://grou=
ps.google.com/forum/#!topic/linux-sunxi/O0Za7H5_jQI
> V4 Changes since V3:
> It use smp_prepare_cpus replacing early_init as cpuconfigure map init fun=
cation caller and use sun7i replacing sunxi7i as funcation name and variabl=
e name.
> V5 Changes since V4:
> Move smp from struct DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tr=
ee)") to struct DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family") =
in file sunxi.c
>=20
> *** BLURB HERE ***

Seriously?

I explained to you several times what we were expecting, with references
to examples of what you should do, and you're still not listening?

You just make me feel like I'm wasting my time here. If you don't want
to make any effort, I won't either.

This is my last warning. Here is what is wrong about your patchset:
  - Wrap your commit log and cover letter to 80 chars
  - You don't have any introduction letter
  - The prefix is wrong, again, while you had it fixed in your v4

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--YIbTR3mqhHpBjtK1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSZ7JGAAoJEBx+YmzsjxAgv60P/1xLktm7AD9RCfGZBHXq9uu7
ATuSfegUd1Y8Yj+PsXHnOhDcvBbW0scl2UZqgfQ2nui5O7jEngbN6pB7c1L1i2Wd
3hrHonqvuefukDMbYj1hggmWI2jG3FlIiaowHVGBrb+Uj2k5nvTBrKFv4ADNzFkk
U/22FlVX2b9+h54upaWUuGm2PYdil8ILTt1cGcYETJVPNrUkAV0eMStmbY4tMxtW
ty7iYLFqfuYCTlD0FgXdzoxPu+5GBSPXNBHODR+GQXn2pxzy9qn0dvPbaeCy0i7v
VEUEvW8J8ecjCURZylQ761YZuoKOXoR2jv8DFhdc4chg/J7R+OfQJnxASnBMNoyx
mDw0a/ECRwf53yQ2SGrm6zjUgGy0YdKmtTaO8q70EUIkoLhn6iKbLZjYjOensSdc
uPGoToot0QN96Fwb7JpNOu9zg6vbQiVZsJCLVuP9rOsO6TGNKGw0OHhnsOBUViIF
cwlL3832sK9nhTfHadGnZZ7LZOQ+WWAqlyWzkWreahc66KJPRK3BeiFcco7EfHMt
dPRI6wcHvlBLRswDTehHcEgj3pzjLq0yVRrAG+25rYdn7Tuiz7F1Y/viEyBLbCVO
D7i+oSC700FN7DEuIuq++T/sWpqNC1NrWR1etSgrJCKD/lLDIJRQ9J3MORD11LVU
5TWKXoXX86JAuyG6M/tF
=BAT4
-----END PGP SIGNATURE-----

--YIbTR3mqhHpBjtK1--
