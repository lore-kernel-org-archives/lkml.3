Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbbAWNQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:16:10 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64001 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbbAWNQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:16:00 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "linux-omap" <linux-omap@vger.kernel.org>
Subject: N900 v3.19-rc5 errors
Date: Fri, 23 Jan 2015 14:15:56 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4667938.vne30npLRW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501231415.56922@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4667938.vne30npLRW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I'm getting these two errors when booting DT linux v3.19-rc5 in n900 qemu:

[    0.309234] device-tree: Duplicate name in onenand@0,0, renamed to "#1"
[    0.309417] device-tree: Duplicate name in onenand@0,0, renamed to "#2"
[    0.309844] device-tree: Duplicate name in ethernet@gpmc, renamed to "#1"
[    0.309967] device-tree: Duplicate name in ethernet@gpmc, renamed to "#2"


[    0.730743] ------------[ cut here ]------------
[    0.731018] WARNING: CPU: 0 PID: 31 at drivers/memory/omap-gpmc.c:1757=20
gpmc_probe_generic_child+0x128/0x24c()
[    0.731475] enable GPMC debug to configure .dts timings for CS1
[    0.731781] Modules linked in:
[    0.732086] CPU: 0 PID: 31 Comm: kworker/u2:1 Not tainted 3.19.0-rc5+ #2=
34
[    0.732391] Hardware name: Nokia RX-51 board
[    0.732757] Workqueue: deferwq deferred_probe_work_func
[    0.733306] [<c0012678>] (unwind_backtrace) from [<c0010d44>] (show_stac=
k+0x10/0x14)
[    0.733703] [<c0010d44>] (show_stack) from [<c0032194>] (warn_slowpath_c=
ommon+0x84/0xac)
[    0.734130] [<c0032194>] (warn_slowpath_common) from [<c003223c>]=20
(warn_slowpath_fmt+0x2c/0x3c)
[    0.734527] [<c003223c>] (warn_slowpath_fmt) from [<c0308308>]=20
(gpmc_probe_generic_child+0x128/0x24c)
[    0.734954] [<c0308308>] (gpmc_probe_generic_child) from [<c0308578>]=20
(gpmc_probe_dt+0x14c/0x1dc)
[    0.735626] [<c0308578>] (gpmc_probe_dt) from [<c030877c>] (gpmc_probe+0=
x174/0x1c8)
[    0.735992] [<c030877c>] (gpmc_probe) from [<c0263d78>] (platform_drv_pr=
obe+0x48/0x90)
[    0.736358] [<c0263d78>] (platform_drv_probe) from [<c02624ec>] (really_=
probe+0xac/0x1e0)
[    0.736785] [<c02624ec>] (really_probe) from [<c0262718>] (driver_probe_=
device+0x30/0x48)
[    0.737152] [<c0262718>] (driver_probe_device) from [<c0260fe8>] (bus_fo=
r_each_drv+0x4c/0x84)
[    0.737548] [<c0260fe8>] (bus_for_each_drv) from [<c02626a0>] (device_at=
tach+0x5c/0x88)
[    0.737915] [<c02626a0>] (device_attach) from [<c0261c1c>] (bus_probe_de=
vice+0x28/0x98)
[    0.738281] [<c0261c1c>] (bus_probe_device) from [<c0262010>]=20
(deferred_probe_work_func+0x54/0x80)
[    0.738677] [<c0262010>] (deferred_probe_work_func) from [<c0046d48>]=20
(process_one_work+0x280/0x45c)
[    0.739074] [<c0046d48>] (process_one_work) from [<c0047180>] (worker_th=
read+0x230/0x354)
[    0.739440] [<c0047180>] (worker_thread) from [<c004b084>] (kthread+0xcc=
/0xe0)
[    0.739776] [<c004b084>] (kthread) from [<c000dc78>] (ret_from_fork+0x14=
/0x3c)
[    0.740173] ---[ end trace 172dd94cb4e47d45 ]---

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4667938.vne30npLRW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTCSYwACgkQi/DJPQPkQ1JpswCgj8C5kuushthiWfGF42uy/7wZ
ITEAnRx7mEHV4eKiGxOElOvNXyIClC7G
=mvTk
-----END PGP SIGNATURE-----

--nextPart4667938.vne30npLRW--
