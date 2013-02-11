Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3BKGGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:06:31 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52185 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3BKGGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:06:08 -0500
Date: Mon, 11 Feb 2013 17:05:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>, Greg KH <greg@kroah.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20130211170553.be92e728da21554fc73f7dc8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Feb_2013_17_05_53_+1100_PZMzigE.rpTBRWX0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Feb_2013_17_05_53_+1100_PZMzigE.rpTBRWX0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in arch/arm/mac=
h-omap2/board-zoom-peripherals.c between commit 51482be9dcfd ("ARM: OMAP: U=
SB: Add phy binding information") from the usb tree and commit c5913935657f=
 ("ARM: OMAP: zoom: Audio support via the common omap-twl4030 machine drive=
r") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-zoom-peripherals.c
index dc5498b,0745bd9..0000000
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@@ -20,7 -20,7 +20,8 @@@
  #include <linux/wl12xx.h>
  #include <linux/mmc/host.h>
  #include <linux/platform_data/gpio-omap.h>
+ #include <linux/platform_data/omap-twl4030.h>
 +#include <linux/usb/phy.h>
 =20
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>

--Signature=_Mon__11_Feb_2013_17_05_53_+1100_PZMzigE.rpTBRWX0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGIpBAAoJEECxmPOUX5FEBvwP/jXDN0ka/pwZJHwCLjhwDZae
jJJU5dqk7XCuQXo3T2mkYJTPkjpRtTjR5nkCLkpnK+jngxwnse+vSTwENbyqJbPo
CgISde+VGR4GSU6QTP5RKvfqNaYUmo/cx7ZI5eMoWyhAo67eskeISh7DeIq4M3l3
tyugwfpZNXkQJ6/XRPOJJd8WQPOQXHpEIhIVNIcgWHR4KwF7tnlf4mdN1wO/sIRU
06/Qh7j98LB8+qwSPUqzWKbU9KzY6dBKSMZg57XqTMmYtbklT2R5KTsOhQZt0Lns
TDEuW7APpB13pHADeopgkA4EsrT7rTzzW/iMeDuwM/d28m9gVS+B9h65vkyVzi1v
U4Y0nrirX99Sep2TxfJpEMZ5yvnnLfnrp+nIY75JDhyvrxG72KzbfaJeryLyyTss
sTHCRiwjOvT+P9B8azpg+SdXwGPjvAu508BYnjx7A+nkR5WRDYQcrGFz1QmpjsWp
4KwWrfHw9+lpCqGqiXL/PAt5YhDE6YCbKUzIBSi4nh7qUH4Pm5uZCliqt6G9l4dt
ry2sWuRHYz4N58coEKfWc/ogGEV+QkB0BtPQ8De41VaTay+Z1h0EGW8nWUWv+7Me
1emdwb7nmDz/0G60PIE0FiufQx1wnHzJLVFX3c3Y+xB9nX5HJgUO9yPuiheGE4oF
yrIi8GZydFXvxuU/dfYc
=BSzv
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Feb_2013_17_05_53_+1100_PZMzigE.rpTBRWX0--
