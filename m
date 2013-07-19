Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934839Ab3GSBSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 21:18:02 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44410 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab3GSBR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 21:17:59 -0400
Message-ID: <1374196673.8162.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: 88pm800: Depend on MFD_88PM800 rather than
 MFD_88PM800=y
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 09:17:53 +0800
In-Reply-To: <1374196615.8162.1.camel@phoenix>
References: <1374196615.8162.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can be built as a module, make it depend on MFD_88PM800.
Otherwise, we are not able to select this driver when MFD_88PM800=m.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 65b7d5b..b05fa90 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -66,7 +66,7 @@ config REGULATOR_USERSPACE_CONSUMER
 
 config REGULATOR_88PM800
 	tristate "Marvell 88PM800 Power regulators"
-	depends on MFD_88PM800=y
+	depends on MFD_88PM800
 	help
 	  This driver supports Marvell 88PM800 voltage regulator chips.
 	  It delivers digitally programmable output,
-- 
1.8.1.2



