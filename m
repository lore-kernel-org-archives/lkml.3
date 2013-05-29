Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966854Ab3E2Pdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:33:50 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64660 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966826Ab3E2Pdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:33:47 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH 11/11] net: emaclite: Update driver header
Date: Wed, 29 May 2013 17:33:11 +0200
Message-Id: <c0a6ab3410dd6e6a9198a4605993164700d1b965.1369841519.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <131c9262c3094ee3c664bd729a66e0709ceae82c.1369841519.git.michal.simek@xilinx.com>
References: <131c9262c3094ee3c664bd729a66e0709ceae82c.1369841519.git.michal.simek@xilinx.com>
In-Reply-To: <131c9262c3094ee3c664bd729a66e0709ceae82c.1369841519.git.michal.simek@xilinx.com>
References: <131c9262c3094ee3c664bd729a66e0709ceae82c.1369841519.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-27676-1369841624-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-27676-1369841624-0001

Corrent email address and years.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0d8515b..af12314 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -2,9 +2,9 @@
  * Xilinx EmacLite Linux driver for the Xilinx Ethernet MAC Lite device.
  *
  * This is a new flat driver which is based on the original emac_lite
- * driver from John Williams <john.williams@petalogix.com>.
+ * driver from John Williams <john.williams@xilinx.com>.
  *
- * 2007-2009 (c) Xilinx, Inc.
+ * 2007 - 2013 (c) Xilinx, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
--
1.8.2.3


--=_mimegpg-monstr-desktop-27676-1369841624-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGmH9gACgkQykllyylKDCEjqgCffZYwSfazgY2dbMWKOlBwQlvi
TvgAoJQ/jTISuGiWdU/W23MA6lc1C0YQ
=nNtM
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-27676-1369841624-0001--
