Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaLANBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:01:33 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34803 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbaLANBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:01:31 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Laura Abbott <lauraa@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        "Prabhakar\"" <prabhakar.csengg@gmail.com>
Subject: [PATCH v1] lib/genalloc.c: Export devm_gen_pool_create for modules
Date: Mon,  1 Dec 2014 14:00:58 +0100
Message-Id: <2e3f47e730975654f9b6c888a07db6c3f886b892.1417438852.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-29720-1417438860-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-29720-1417438860-0001

Modules can use this function for creating pool.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

I am pushing Zynq OCMC driver which is using this function.

---
 lib/genalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index cce4dd68c40d..2e65d206b01c 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -598,6 +598,7 @@ struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,

 	return pool;
 }
+EXPORT_SYMBOL(devm_gen_pool_create);

 /**
  * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
--
1.8.2.3


--=_mimegpg-monstr-desktop-29720-1417438860-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlR8ZowACgkQykllyylKDCF4qACgnZVP1YNBpKc6XwYgMQJc4wZy
xyoAnArQ3SQTODP1s8JUcnSmuigWZUW0
=7Uuf
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-29720-1417438860-0001--
