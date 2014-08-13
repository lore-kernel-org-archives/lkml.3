Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaHMMGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:06:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47951 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaHMMGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:06:40 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH] MAINTAINERS: Assing systemace driver to Xilinx
Date: Wed, 13 Aug 2014 14:06:36 +0200
Message-Id: <4e1991fb095088a58f226de7070ff0f8dd96be3f.1407931579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-21975-1407931596-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-21975-1407931596-0001

Assign systemace driver to Xilinx Zynq to ensure
if there is a change that someone can even test it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 MAINTAINERS | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e2eb4c646e3..068fb9a9a2fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1503,6 +1503,7 @@ T:	git git://git.xilinx.com/linux-xlnx.git
 S:	Supported
 F:	arch/arm/mach-zynq/
 F:	drivers/cpuidle/cpuidle-zynq.c
+F:	drivers/block/xsysace.c
 N:	zynq
 N:	xilinx
 F:	drivers/clocksource/cadence_ttc_timer.c
@@ -10101,10 +10102,6 @@ M:	John Linn <John.Linn@xilinx.com>
 S:	Maintained
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*

-XILINX SYSTEMACE DRIVER
-S:	Orphan
-F:	drivers/block/xsysace.c
-
 XILINX UARTLITE SERIAL DRIVER
 M:	Peter Korsgaard <jacmet@sunsite.dk>
 L:	linux-serial@vger.kernel.org
--
1.8.2.3


--=_mimegpg-monstr-desktop-21975-1407931596-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPrVMwACgkQykllyylKDCFO5QCfXGSMcxSe4zsG9If3B6FsOY0a
/dAAn3YIsXpLdFEwAkcaahljNdF7kuZQ
=SKe0
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-21975-1407931596-0001--
