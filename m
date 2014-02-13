Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaBMHLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:11:00 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:62030 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaBMHK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:10:56 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: netdev@vger.kernel.org
Cc: Srikanth Thokala <sthokal@xilinx.com>, Michal Simek <monstr@monstr.eu>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] net: axienet: Fix compilation error
Date: Thu, 13 Feb 2014 08:10:42 +0100
Message-Id: <2082312fdbceca394080302b1709a5f71d7d3652.1392275432.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1392275432.git.michal.simek@xilinx.com>
References: <cover.1392275432.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392275432.git.michal.simek@xilinx.com>
References: <cover.1392275432.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8705-1392275452-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8705-1392275452-0001

Add missing header to fix compilation error.
drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1575:22:
 error: undefined identifier 'irq_of_parse_and_map'
drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1576:22:
 error: undefined identifier 'irq_of_parse_and_map'

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v2: None

 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 1ec65fe..9fb8ab2 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -26,6 +26,7 @@
 #include <linux/netdevice.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
+#include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
--
1.8.2.3


--=_mimegpg-monstr-desktop-8705-1392275452-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL8b/wACgkQykllyylKDCHfoQCfX6mutJlDnfLniVfFRfQkW0DK
5BkAn0Gyfiw8WvJedqXhxM3QijEgEmE7
=mr9a
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8705-1392275452-0001--
