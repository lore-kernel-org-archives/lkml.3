Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030228AbaGOXYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:24:52 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:57125 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965264AbaGOXYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:24:48 -0400
Subject: [PATCH] Input: sirfsoc-onkey - fix GPL v2 license string typo
To: Barry Song <baohua@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Binghua Duan <Binghua.Duan@csr.com>, Xianglong Du <Xianglong.Du@csr.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Jul 2014 17:24:45 -0600
Message-ID: <20140715232445.24052.13767.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per license_is_gpl_compatible(), the MODULE_LICENSE() string for GPL v2 is
"GPL v2", not "GPLv2".  Use "GPL v2" so this module doesn't taint the
kernel.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/input/misc/sirfsoc-onkey.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/sirfsoc-onkey.c b/drivers/input/misc/sirfsoc-onkey.c
index e4104f9b2e6d..fed5102e1802 100644
--- a/drivers/input/misc/sirfsoc-onkey.c
+++ b/drivers/input/misc/sirfsoc-onkey.c
@@ -213,7 +213,7 @@ static struct platform_driver sirfsoc_pwrc_driver = {
 
 module_platform_driver(sirfsoc_pwrc_driver);
 
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Binghua Duan <Binghua.Duan@csr.com>, Xianglong Du <Xianglong.Du@csr.com>");
 MODULE_DESCRIPTION("CSR Prima2 PWRC Driver");
 MODULE_ALIAS("platform:sirfsoc-pwrc");

