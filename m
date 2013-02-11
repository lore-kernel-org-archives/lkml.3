Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab3BKGGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:06:30 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41128 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3BKGGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:06:12 -0500
Date: Mon, 11 Feb 2013 17:06:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20130211170610.d3df28e80424e7c8fd9233e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Feb_2013_17_06_10_+1100_9bqY3_O62avqYFx="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Feb_2013_17_06_10_+1100_9bqY3_O62avqYFx=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/board-3430sdp.c between commit 51482be9dcfd ("ARM:
OMAP: USB: Add phy binding information") from the usb tree and commit
77f86144984e ("ARM: OMAP: sdp3430: Audio support via the common
omap-twl4030 machine driver") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-3430sdp.c
index 2a739b2,4f17339..0000000
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@@ -25,7 -25,7 +25,8 @@@
  #include <linux/gpio.h>
  #include <linux/mmc/host.h>
  #include <linux/platform_data/spi-omap2-mcspi.h>
+ #include <linux/platform_data/omap-twl4030.h>
 +#include <linux/usb/phy.h>
 =20
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>

--Signature=_Mon__11_Feb_2013_17_06_10_+1100_9bqY3_O62avqYFx=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGIpSAAoJEECxmPOUX5FErWQP/0+Zz9lMuj07+zwkKEF55seg
VdYo08wv8gCdaKKX/Q4tsxWwdOUgDYUtTHV5I1dQdJOVjYZB5Jw1uygFBUxtqAzK
icUo8Zqa6Kl1a8lGN0YvvQjYMltH/jXXObdRs4ZteQIMVdQY4ELN/lFZHpJL1q7E
wfXBnzCWpfft72zrhVkyZXswNAHhYxzBwhn4PviZvPOR2a7NGc933hGFLFcV0jfO
uXr9alqEK3Kl/QYfbxe6uSDuZ1t6NXpSCCRNXMTiEieHWttqegh4MOdQ0ft950s6
VmtIfeucLVfdshDT/z0B6YmG34+wm7Q3LKjofajGBEA/lqfvXhQC6zIzAac10X1w
26lWszx54sgv9jkRejhFfmj3M5mF3XNgHJk6lJ4Lx1yl5LoyjrVB/MP9vFbu/0Hj
MzPNZ8h3hOBL7zC40qIvgi5lyY3w9xpUYU2f8sdvZsH8r3ZAiyksQqsPYcLFNq8s
afjyLINujqBPi51QSMCdW4+xyCxBQGusb4nq7ydp3Xq2eS5CCBlZ4LMkuGWqpVmf
+U2f+gub8e3KlXhQwhRHBTiqQTpfIIdAUw15mM+QDjHEdhXGfiPjTofMK4uvEMkB
cjmHFBfkmCIIpNLEmtKPFRioa03HHPRkNPmizgec8uOKhIGn0N6HyWI04ofrzPRO
JYqa/mw18B8tfNH8iN/q
=px6z
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Feb_2013_17_06_10_+1100_9bqY3_O62avqYFx=--
