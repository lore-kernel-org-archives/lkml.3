Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab3FUGIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:08:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58747 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3FUGID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:08:03 -0400
Date: Fri, 21 Jun 2013 16:08:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the mailbox tree
Message-Id: <20130621160800.64f9965229e5042a7b77e212@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_16_08_00_+1000_w1f/5NJXWqxHC7U."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_16_08_00_+1000_w1f/5NJXWqxHC7U.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/devices.c between commit 4a1c0e83bb4e ("ARM: OMAP2+:
mbox: remove dependencies with soc.h") from the mailbox tree and commit
82c5cde1c4b0 ("ARM: OMAP2+: Remove omap4 ocp2scp pdata") from the arm-soc
tree.

I fixed it up (removing the include of
linux/platform_data/omap_ocp2scp.h) and can carry the fix as necessary
(no action is required).

That mailbox tree commit looks very similar to commit b8a7cf8e2b15 ("ARM:
OMAP2+: mbox: remove dependencies with soc.h") from the arm-soc tree ...

As an aside, the include of linux/usb/omap_control_usb.h into this file
was removed by commit 608d19380c67 ("ARM: OMAP2+: Remove omap4 pdata for
USB") in the arm-soc tree, but reintroduced by commit 435f4c6d5242
("Merge branch 'next/drivers' into for-next").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Jun_2013_16_08_00_+1000_w1f/5NJXWqxHC7U.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRw+3AAAoJEECxmPOUX5FEyRoP/judkb5/zY9qq4HC0eLnPmnr
L9Uhzriu8vL9/2JKe17bs4Ri3HeDV7Oj0OslBBDi0ozN9VjEGVxoniCXxgzK+hVZ
sZKBnZYFr1m3hMyu2xk87FOBRaB5LJfLfgx1Qe1f4kQlu8x4mktTY+RNk3j4SDv7
YXEN3cILVcsmChBg+TGjD4scQJ1jMj8jNV2dhuiIDZlKBnwSYTc0+VHCXHgneU8o
MjtukQJclZ8m+c3sMTxQHXEE3pM2MmVIUJUjcfMmNrufYAcLci1BJbng5WL+OIMp
oj8LZmcGLZPW9cEX37pJ4lU/x35U3cjg74+7ntlxADnaXyPDykZgjAraj1MTRzH/
YsRrZVa6o27cSgGExFwRu0o5gLpk3qtHSc594lrA6WZ/xwAo+ejlmYsS9E0t0VMW
PycQc4MuoGqJ8w5KmiOr9CHSZ2p/M+hB+Ic9+oJNu+gArASAEoyrmc2ySrEIhq2L
uUo0bXPBlD7XaCVG0YgTR7OFCkkJfPHZno0d54ELwRKAPeg/zAA/yoceN+cY1XBE
mhBurPBWw7SHPjLjVQNNzTmR91oKec/L4tZPSs8CvbSq4EtZCxhhYN5tUwnfXVSD
Co8hwP2ARKg2I0yGLg4tANuVH5OR/dQ4dhZ4LLCWJY7NSv9vUFfrQhhB/+M+qwn9
OypR6TJE8ewpapveEqDp
=wV/7
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_16_08_00_+1000_w1f/5NJXWqxHC7U.--
