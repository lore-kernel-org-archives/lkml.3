Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaEOH2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:28:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62834 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaEOH2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:28:04 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: git@xilinx.com
Subject: [PATCH] microblaze: Enable SERIAL_OF_PLATFORM
Date: Thu, 15 May 2014 09:27:39 +0200
Message-Id: <21b32ad4e83fbfe177ae4f95fd7ef73672746128.1400138832.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-7422-1400138859-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-7422-1400138859-0001

SERIAL_OF_PLATFORM is required for getting 8250 to work.

Reported-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/microblaze/configs/mmu_defconfig   | 1 +
 arch/microblaze/configs/nommu_defconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
index deaf45ab6429..e2f6543b91e7 100644
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -49,6 +49,7 @@ CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_UARTLITE=y
 CONFIG_SERIAL_UARTLITE_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_XILINX_HWICAP=y
 CONFIG_I2C=y
diff --git a/arch/microblaze/configs/nommu_defconfig b/arch/microblaze/configs/nommu_defconfig
index 10b5172283d7..a29ebd4a9fcb 100644
--- a/arch/microblaze/configs/nommu_defconfig
+++ b/arch/microblaze/configs/nommu_defconfig
@@ -58,6 +58,7 @@ CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_UARTLITE=y
 CONFIG_SERIAL_UARTLITE_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_XILINX_HWICAP=y
 CONFIG_I2C=y
--
1.8.2.3


--=_mimegpg-monstr-desktop-7422-1400138859-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlN0bGwACgkQykllyylKDCEZqACdGtzp5g0vcI1GwjDazTcvk8Gi
hc8AnR9+raSYCDlxmBY3jAUulmp4+aJs
=zobN
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-7422-1400138859-0001--
