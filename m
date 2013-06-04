Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3FDMVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:21:02 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64208 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3FDMU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:20:59 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] tty: serial: Enable uartlite for ARM zynq
Date: Tue,  4 Jun 2013 14:20:43 +0200
Message-Id: <26d21aaa1f4a5b3bcae1d82f1524ea53ce9a36bd.1370348438.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-13300-1370348443-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-13300-1370348443-0001

Enable it in Kconfig.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 7e7006f..64250b1 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -576,7 +576,7 @@ config SERIAL_IMX_CONSOLE

 config SERIAL_UARTLITE
 	tristate "Xilinx uartlite serial port support"
-	depends on PPC32 || MICROBLAZE || MFD_TIMBERDALE
+	depends on PPC32 || MICROBLAZE || MFD_TIMBERDALE || ARCH_ZYNQ
 	select SERIAL_CORE
 	help
 	  Say Y here if you want to use the Xilinx uartlite serial controller.
--
1.8.2.3


--=_mimegpg-monstr-desktop-13300-1370348443-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGt25wACgkQykllyylKDCH3rQCeN61WmWg4aPcOXEBqJCv0uwV0
QFIAoJW5lP2ESEfZ70v/Wy/GKaeEEs51
=lMXc
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-13300-1370348443-0001--
