Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaIAO0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:26:24 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:34302 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbaIAO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:26:22 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Subject: [PATCH 2/2] microblaze: Rename Advance setup to Kernel features
Date: Mon,  1 Sep 2014 16:26:09 +0200
Message-Id: <74e465f95e7bdcd9d5a71abdfdd5c35463af8b12.1409581564.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <deb0c99660e9a97a0c5af96105199998cb852add.1409581564.git.michal.simek@xilinx.com>
References: <deb0c99660e9a97a0c5af96105199998cb852add.1409581564.git.michal.simek@xilinx.com>
In-Reply-To: <deb0c99660e9a97a0c5af96105199998cb852add.1409581564.git.michal.simek@xilinx.com>
References: <deb0c99660e9a97a0c5af96105199998cb852add.1409581564.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23606-1409581577-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23606-1409581577-0001

"Advance setup: menu is misleading that's why rename it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/microblaze/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index beb9c3fe7e38..6feded3b0c4c 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -127,7 +127,7 @@ config SECCOMP

 endmenu

-menu "Advanced setup"
+menu "Kernel features"

 config ADVANCED_OPTIONS
 	bool "Prompt for advanced kernel configuration options"
--
1.8.2.3


--=_mimegpg-monstr-desktop-23606-1409581577-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQEggkACgkQykllyylKDCGE9wCeMWCoE/hhi/80pCroPELN42KX
LPsAn0vkaHA8uX3FD7SG2vlpRyx10X97
=3iaW
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23606-1409581577-0001--
