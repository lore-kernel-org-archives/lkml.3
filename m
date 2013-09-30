Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3I3HFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:05:11 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:56239 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3I3HFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:05:09 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, monstr@monstr.eu
Cc: vinod.koul@intel.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: amba: Extend number of IRQS
Date: Mon, 30 Sep 2013 09:05:05 +0200
Message-Id: <0a5b86b1a90ff48133a1f0d43e342bec9da8fa57.1380524685.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17048-1380524705-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17048-1380524705-0001

Xilinx Zynq pl330 dma driver has 9 irqs which all have to
be used by the driver to get it work properly.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Not sure if there are others IP with more than 9 irqs.
---
 include/linux/amba/bus.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 43ec7e2..b327a1b 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -21,7 +21,7 @@
 #include <linux/resource.h>
 #include <linux/regulator/consumer.h>

-#define AMBA_NR_IRQS	2
+#define AMBA_NR_IRQS	9
 #define AMBA_CID	0xb105f00d

 struct clk;
--
1.8.2.3


--=_mimegpg-monstr-desktop-17048-1380524705-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJJIqEACgkQykllyylKDCFatACfTf/RMFzrMuCk5D7POHJSL8Ez
RC8An2VZFwHg/0jFpS4dapc378jx39CC
=Kanj
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17048-1380524705-0001--
