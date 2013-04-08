Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762Ab3DHDFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 23:05:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42939 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934720Ab3DHDFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 23:05:05 -0400
Date: Mon, 8 Apr 2013 13:04:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make do_sysinfo() static
Message-Id: <20130408130455.5337ef8d9a93f9285de1a396@canb.auug.org.au>
In-Reply-To: <20130408020011.GQ4068@ZenIV.linux.org.uk>
References: <20130408115325.1e4b35359271383b9c459ef9@canb.auug.org.au>
	<20130408020011.GQ4068@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Apr_2013_13_04_55_+1000_mUmBL+=7ZE729zJ7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Apr_2013_13_04_55_+1000_mUmBL+=7ZE729zJ7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Mon, 8 Apr 2013 03:00:11 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> On Mon, Apr 08, 2013 at 11:53:25AM +1000, Stephen Rothwell wrote:
> > The only use outside of kernel/timer.c was in kernel/compat.c, so move
> > compat_sys_sysinfo() next to sys_sysinfo() in kernel/timer.c.
>=20
> Please, switch it to COMPAT_SYSCALL_DEFINE, while you are at it.

I would prefer someone do that as a separate patch as this is a "no
logical change" patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Apr_2013_13_04_55_+1000_mUmBL+=7ZE729zJ7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRYjPXAAoJEECxmPOUX5FExvgQAKlq0iMm/i7e+TwOhe/vsEa8
ZZq3k0hTLch7cV/NLFI9tNGUH6jFzHGG1XNC74aJt8vb2kbKB4A2c2+ChegqNaFg
H0NuTFw29N7lgCgRHY2raLD4cQc7cCBjJXXTEIcZonDHPcSp32ph+wy0uzCcaX5D
OK3y0YEsDxT4m8MW4aPH4TSx3QBY0Dc8IZUugw2GkY03cYPN2LMFjqbHagtNMtdq
Pi4K1dWqkkawQ5KuwySxn6okC+vpXSwjZJObo5QgqqoIBv5uc/Ppmo3Il0fK5Cqb
eEa5SC74W/8cBiZv4yzs9rKblELirWd8rqPFov+1v9YiR+VQsufP7FyvThuhaan+
OvfdHu43hhBZBtKvO9+vGCzpMlbCP79r5Db7iyWk8ZVSFsuX2Ypq5IRMJTA+9gsR
Pw0Gre/7Lvm8QHamerDEU3COsMiEtru6qwh1WlHWtXwywFbDrxJEMwJc2q9uk/hD
LYvtqLm2bYvCKmXeBVW/PVOn7KP2CQjslHXacJatoBN+jiWaW3YJaXgpAdnmCsTO
zFrqK8q3glwl0y+9VkSrB2528r3QoXGaK3D806GyKStG9KAOxPtre05YZBPxIpnj
ozmPdsTGZN36QFi3KhWL47lDSKyWZ4HtLKLvXVXQZofW0EsSVc06cic1KMHsqCPm
KIXzQ+ngWJ3GwZgT3HM0
=9qhM
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Apr_2013_13_04_55_+1000_mUmBL+=7ZE729zJ7--
