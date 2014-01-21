Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaAUKdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:33:50 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56622 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbaAUKdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:33:43 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] tty: uartps: Get rid of Xilinx PS name
Date: Tue, 21 Jan 2014 11:33:11 +0100
Message-Id: <82f1a903f281c73683c5e69cac0206759561cccd.1390300383.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <7d0c02bf2d7eb816eb505d04c3800112805e2b62.1390300383.git.michal.simek@xilinx.com>
References: <7d0c02bf2d7eb816eb505d04c3800112805e2b62.1390300383.git.michal.simek@xilinx.com>
In-Reply-To: <7d0c02bf2d7eb816eb505d04c3800112805e2b62.1390300383.git.michal.simek@xilinx.com>
References: <7d0c02bf2d7eb816eb505d04c3800112805e2b62.1390300383.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-13110-1390300419-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-13110-1390300419-0001

Use zynq name instead.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index b2f929e..528f16a 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1,5 +1,5 @@
 /*
- * Xilinx PS UART driver
+ * Xilinx Zynq UART driver
  *
  * 2011 - 2013 (C) Xilinx Inc.
  *
--
1.8.2.3


--=_mimegpg-monstr-desktop-13110-1390300419-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLeTQMACgkQykllyylKDCGo5ACeJy6+wYLcYOF/5r4+efI8bo+E
HAsAnA/dZzDEMYQ3G7SMF7bOzUNf9AFV
=imoB
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-13110-1390300419-0001--
