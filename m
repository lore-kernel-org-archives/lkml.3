Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab3EWMwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:52:41 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60056 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991Ab3EWMwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:52:39 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] char: xilinx_hwicap: Checkpatch.pl cleanup
Date: Thu, 23 May 2013 14:52:33 +0200
Message-Id: <113e9af3a4a45647da48d04b68cfc50aade0fb0c.1369313543.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-15199-1369313554-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-15199-1369313554-0001

Remove checkpatch warning:
WARNING: Use #include <linux/io.h> instead of <asm/io.h>

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/char/xilinx_hwicap/xilinx_hwicap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.h b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
index d31ee23..96677fc 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.h
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
@@ -37,7 +37,7 @@
 #include <linux/cdev.h>
 #include <linux/platform_device.h>

-#include <asm/io.h>
+#include <linux/io.h>

 struct hwicap_drvdata {
 	u32 write_buffer_in_use;  /* Always in [0,3] */
--
1.8.2.3


--=_mimegpg-monstr-desktop-15199-1369313554-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGeERIACgkQykllyylKDCF33QCgheCxf3Pfg74p+vkJAAqF1fq/
+2wAnRhl0ecwK9aY9em20M0pfUWPyVi7
=1YP7
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-15199-1369313554-0001--
