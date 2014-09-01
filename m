Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaIAO0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:26:20 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41998 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbaIAO0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:26:18 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Subject: [PATCH 1/2] microblaze: Add mm/Kconfig to advance menu
Date: Mon,  1 Sep 2014 16:26:08 +0200
Message-Id: <deb0c99660e9a97a0c5af96105199998cb852add.1409581564.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23592-1409581569-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23592-1409581569-0001

mm/Kconfig is getting too big to be in root menu.
Move it to submenu.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/microblaze/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 40e1c1dd0e24..beb9c3fe7e38 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -248,10 +248,10 @@ config MICROBLAZE_64K_PAGES

 endchoice

-endmenu
-
 source "mm/Kconfig"

+endmenu
+
 menu "Executable file formats"

 source "fs/Kconfig.binfmt"
--
1.8.2.3


--=_mimegpg-monstr-desktop-23592-1409581569-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQEggEACgkQykllyylKDCEXWgCfYC9XLFzNh21PrOEYcfgenwZX
+uMAnj+vFu94Brrpg3XbnEh6/RdES3SP
=Ho0O
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23592-1409581569-0001--
