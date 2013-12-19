Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3LSP2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:28:05 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:33731 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3LSP2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:28:02 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        linux-arm-kernel@lists.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] MAINTAINERS: Setup proper record for Xilinx Zynq
Date: Thu, 19 Dec 2013 16:27:55 +0100
Message-Id: <3dac35ceaef6199c5a58bba17ce59f1ef0e2bf1e.1387466706.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-16885-1387466875-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-16885-1387466875-0001

Setup correct zynq entry.
- Add missing cadence_ttc_timer maintainership
- Add zynq wildcard
- Add xilinx wildcard

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1344816..5f6e3ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1366,6 +1366,9 @@ T:	git git://git.xilinx.com/linux-xlnx.git
 S:	Supported
 F:	arch/arm/mach-zynq/
 F:	drivers/cpuidle/cpuidle-zynq.c
+N:	zynq
+N:	xilinx
+F:	drivers/clocksource/cadence_ttc_timer.c

 ARM SMMU DRIVER
 M:	Will Deacon <will.deacon@arm.com>
--
1.8.2.3


--=_mimegpg-monstr-desktop-16885-1387466875-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlKzEHsACgkQykllyylKDCEwqACgmTWk4x08T//hdpGCwu69Fj3X
LwsAnRCV5L2cng+Rybr04N+w/8VV/42g
=gkix
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-16885-1387466875-0001--
