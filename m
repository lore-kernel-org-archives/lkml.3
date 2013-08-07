Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3HGA4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:56:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33065 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3HGA4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:56:16 -0400
Message-ID: <1375836970.4861.2.camel@phoenix>
Subject: [PATCH] regulator: fan53555: Prevent multiple include of fan53555.h
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yunfan Zhang <yfzhang@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 07 Aug 2013 08:56:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add define for __FAN53555_H__ to prevent multiple include of the header file.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 include/linux/regulator/fan53555.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/regulator/fan53555.h b/include/linux/regulator/fan53555.h
index 5c45c85..f13880e 100644
--- a/include/linux/regulator/fan53555.h
+++ b/include/linux/regulator/fan53555.h
@@ -11,6 +11,7 @@
  */
 
 #ifndef __FAN53555_H__
+#define __FAN53555_H__
 
 /* VSEL ID */
 enum {
-- 
1.8.1.2



