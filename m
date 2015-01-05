Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbbAELju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:39:50 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46469 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbbAELjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:39:49 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Erico Nunes <nunes.erico@gmail.com>
Subject: [PATCH] microblaze: Add target architecture
Date: Mon,  5 Jan 2015 12:33:00 +0100
Message-Id: <4e509cfccd8a6f9fab636418e683f101e6ea6c3d.1420457573.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-11361-1420457580-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-11361-1420457580-0001

Add missing target architectures - virtex7, ultrascale virtex
and ultrascale kintex.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/microblaze/kernel/cpu/cpuinfo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
index b60442dcdedc..d1dd6e83d59b 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -65,11 +65,14 @@ const struct family_string_key family_string_lookup[] = {
 	{"spartan3adsp", 0xc},
 	{"spartan6", 0xd},
 	{"virtex6", 0xe},
+	{"virtex7", 0xf},
 	/* FIXME There is no key code defined for spartan2 */
 	{"spartan2", 0xf0},
 	{"kintex7", 0x10},
 	{"artix7", 0x11},
 	{"zynq7000", 0x12},
+	{"UltraScale Virtex", 0x13},
+	{"UltraScale Kintex", 0x14},
 	{NULL, 0},
 };

--
1.8.2.3


--=_mimegpg-monstr-desktop-11361-1420457580-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlSqdmwACgkQykllyylKDCE3UwCggPFhskWCzMaF3bKpMbbtA3mF
XUYAoIGfrkIxJjvkRCeNlHbu9n1njph3
=RdHS
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-11361-1420457580-0001--
