Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3LRVOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:14:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3LRVN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Robin Gong <b38343@freescale.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 045/118] regulator: pfuze100: Fix address of FABID
Date: Wed, 18 Dec 2013 13:11:22 -0800
Message-Id: <20131218211220.749002425@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit a1b6fa85c639ad0d5447d1a5e7d1463bbe29fcd3 upstream.

According to the datasheet, the address of FABID is 0x4. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Robin Gong <b38343@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/pfuze100-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -38,7 +38,7 @@
 
 #define PFUZE100_DEVICEID	0x0
 #define PFUZE100_REVID		0x3
-#define PFUZE100_FABID		0x3
+#define PFUZE100_FABID		0x4
 
 #define PFUZE100_SW1ABVOL	0x20
 #define PFUZE100_SW1CVOL	0x2e


