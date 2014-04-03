Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaDCPHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:07:17 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43660 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaDCPHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:07:11 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clk: si570: Fix email address specifiction
Date: Thu,  3 Apr 2014 17:06:57 +0200
Message-Id: <07ad0bb4b386c644e70913262b281feb0c2230cb.1396537609.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-26026-1396537617-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-26026-1396537617-0001

Just fix missing ">" in the email.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/clk/clk-si570.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
index 4bbbe32..fc167b3 100644
--- a/drivers/clk/clk-si570.c
+++ b/drivers/clk/clk-si570.c
@@ -526,6 +526,6 @@ static struct i2c_driver si570_driver = {
 module_i2c_driver(si570_driver);

 MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
-MODULE_AUTHOR("Soeren Brinkmann <soren.brinkmann@xilinx.com");
+MODULE_AUTHOR("Soeren Brinkmann <soren.brinkmann@xilinx.com>");
 MODULE_DESCRIPTION("Si570 driver");
 MODULE_LICENSE("GPL");
--
1.8.2.3


--=_mimegpg-monstr-desktop-26026-1396537617-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlM9eREACgkQykllyylKDCGJfQCeJt/LI1bKqXvgYdZTlpFGPfLT
7eUAoIh5AxsbKw1V8sksPH7PZzvpDUHP
=K8Pe
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-26026-1396537617-0001--
