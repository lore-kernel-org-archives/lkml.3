Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab3FCMch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:32:37 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54419 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633Ab3FCMcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:32:06 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 5/6] GPIO: xilinx: Enable driver for Xilinx zynq
Date: Mon,  3 Jun 2013 14:31:20 +0200
Message-Id: <908b1f3742760cadffda31af8dadb82f55c4a754.1370262666.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25610-1370262722-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25610-1370262722-0001

Enable gpio driver for usage on Xilinx ARM zynq platform.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2:
- New patch in this series

 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 573c449..9dea98e 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -234,7 +234,7 @@ config GPIO_TS5500

 config GPIO_XILINX
 	bool "Xilinx GPIO support"
-	depends on PPC_OF || MICROBLAZE
+	depends on PPC_OF || MICROBLAZE || ARCH_ZYNQ
 	help
 	  Say yes here to support the Xilinx FPGA GPIO device

--
1.8.2.3


--=_mimegpg-monstr-desktop-25610-1370262722-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsjMIACgkQykllyylKDCEy7ACfb4/jyT77JFa9exVUKuZ7oT8O
Jm0An2fTrelumg4pJSQR+VQXVXiaMF9m
=oc+m
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25610-1370262722-0001--
