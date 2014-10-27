Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaJ0IYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:24:53 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36660 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaJ0IYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:24:51 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Subject: [PATCH 1/3] microblaze: Fix missing NR_CPUS in menuconfig
Date: Mon, 27 Oct 2014 09:24:33 +0100
Message-Id: <4cbbbb43d666468d87f99676cf05fb5154d1228b.1414398260.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25718-1414398275-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25718-1414398275-0001

The time Kconfig expects that NR_CPUS is defined.

This patch remove this config warning:
"kernel/time/Kconfig:163:warning: range is invalid"

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/microblaze/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 6feded3b0c4c..a7736fa0580c 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -129,6 +129,10 @@ endmenu

 menu "Kernel features"

+config NR_CPUS
+	int
+	default "1"
+
 config ADVANCED_OPTIONS
 	bool "Prompt for advanced kernel configuration options"
 	help
--
1.8.2.3


--=_mimegpg-monstr-desktop-25718-1414398275-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlROAUMACgkQykllyylKDCGhUgCglsMyPEZQHhkWCeVaOcTfrGbA
KksAn2bEkErEm2+QLu8hhQswkebGzpUp
=VU/t
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25718-1414398275-0001--
