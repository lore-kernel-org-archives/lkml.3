Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228AbaLKJAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:00:23 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49944 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934214AbaLKJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:00:20 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Subject: [PATCH] kconfig: Use macros which are already defined
Date: Thu, 11 Dec 2014 10:00:08 +0100
Message-Id: <fa1a28d64cb484535e355f364b49f5ab42b98f46.1418288403.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-19329-1418288408-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-19329-1418288408-0001

It is better to use macros which are already available
because then there is just one location which needs to be change.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

FYI: Fengguang's testing system doesn't show any build error.
---
 include/linux/kconfig.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
index be342b94c640..71acdf650e2e 100644
--- a/include/linux/kconfig.h
+++ b/include/linux/kconfig.h
@@ -28,7 +28,7 @@
  *
  */
 #define IS_ENABLED(option) \
-	(config_enabled(option) || config_enabled(option##_MODULE))
+	(IS_BUILTIN(option) || IS_MODULE(option))

 /*
  * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
--
1.8.2.3


--=_mimegpg-monstr-desktop-19329-1418288408-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlSJXRgACgkQykllyylKDCFR0gCcCD29wrEF/udFgBlKsuta/oQm
6l0AnAyzt5u+x3J0n1ZSTmR3RVyLBDrc
=UKHk
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-19329-1418288408-0001--
