Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab3FMSaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:30:10 -0400
Received: from etezian.org ([198.101.225.253]:56459 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758954Ab3FMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:29:00 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 02/19] bh1770glc: different glass attenuation parameters
Date: Thu, 13 Jun 2013 20:20:36 +0200
Message-Id: <bb0e82c085a5497a9567fd227f33544093db5b06.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

The Ambient Light Sensor (ALS) glass attenuation parameter should
be configurable and two new parameters are introduced:
als_scf_BH1770 and als_scf_SFH7770.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 include/linux/i2c/bh1770glc.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/i2c/bh1770glc.h b/include/linux/i2c/bh1770glc.h
index 8b5e2df..a08060a 100644
--- a/include/linux/i2c/bh1770glc.h
+++ b/include/linux/i2c/bh1770glc.h
@@ -47,6 +47,8 @@ struct bh1770_platform_data {
 	__u8 led_def_curr;
 #define BH1770_NEUTRAL_GA 16384 /* 16384 / 16384 = 1 */
 	__u32 glass_attenuation;
+	__u32 als_scf_BH1770;
+	__u32 als_scf_SFH7770;
 	int (*setup_resources)(void);
 	int (*release_resources)(void);
 };
-- 
1.7.10.4

