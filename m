Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaCKMXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:23:33 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44861 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaCKMXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:23:31 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH] usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210
Date: Tue, 11 Mar 2014 13:23:14 +0100
Message-Id: <53e70779e1467e9fa358db0d4a319824c5173b82.1394540587.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-20387-1394540595-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-20387-1394540595-0001

Add new ulpi IDs which are available on Xilinx Zynq boards.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

http://www.ti.com/lit/ds/symlink/tusb1210.pdf page 29
I don't know why but value is not written in smsc manual here.
http://ww1.microchip.com/downloads/en/DeviceDoc/3320.pdf
page 62

---
 drivers/usb/phy/phy-ulpi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/phy/phy-ulpi.c b/drivers/usb/phy/phy-ulpi.c
index 217339d..17ea3f2 100644
--- a/drivers/usb/phy/phy-ulpi.c
+++ b/drivers/usb/phy/phy-ulpi.c
@@ -47,6 +47,8 @@ struct ulpi_info {
 static struct ulpi_info ulpi_ids[] = {
 	ULPI_INFO(ULPI_ID(0x04cc, 0x1504), "NXP ISP1504"),
 	ULPI_INFO(ULPI_ID(0x0424, 0x0006), "SMSC USB331x"),
+	ULPI_INFO(ULPI_ID(0x0424, 0x0007), "SMSC USB3320"),
+	ULPI_INFO(ULPI_ID(0x0451, 0x1507), "TI TUSB1210"),
 };

 static int ulpi_set_otg_flags(struct usb_phy *phy)
--
1.8.2.3


--=_mimegpg-monstr-desktop-20387-1394540595-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlMfADMACgkQykllyylKDCHjrACfZLtNFGy5cRMgIOr0aA7FzvUi
xyEAoJovSn315tfi9jhE1W8tHqa7nnWU
=iYeu
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-20387-1394540595-0001--
