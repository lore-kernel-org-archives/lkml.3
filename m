Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937313Ab3DJWrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:47:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937226Ab3DJWrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Magnus Myrstedt <magnus.p.persson@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 42/64] crypto: ux500 - add missing comma
Date: Wed, 10 Apr 2013 15:46:39 -0700
Message-Id: <20130410224343.051755359@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit d47cbd5bcee7c7a08fc0283dda465375fa1b1fda upstream.

Commit 4f31f5b19eb0418a847b989abc9ac22af1991fe2
"PM / crypto / ux500: Use struct dev_pm_ops for power management"
add a new line to the driver struct but missed to add a
trailing comma, causing build errors when crypto is
selected. This adds the missing comma.

This was not noticed until now because the crypto block
is not in the ux500 defconfig. A separate patch will
be submitted to fix this.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Magnus Myrstedt <magnus.p.persson@stericsson.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ux500/cryp/cryp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1750,7 +1750,7 @@ static struct platform_driver cryp_drive
 	.shutdown = ux500_cryp_shutdown,
 	.driver = {
 		.owner = THIS_MODULE,
-		.name  = "cryp1"
+		.name  = "cryp1",
 		.pm    = &ux500_cryp_pm,
 	}
 };


