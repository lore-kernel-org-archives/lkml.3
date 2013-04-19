Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581Ab3DSMrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:47:35 -0400
Received: from mail.neotion.com ([91.121.222.125]:56097 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030356Ab3DSMrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:47:33 -0400
Message-ID: <51713B7B.3060402@neotion.com>
Date: Fri, 19 Apr 2013 14:41:31 +0200
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
Organization: Neotion
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-mmc@vger.kernel.org
CC: Chris Ball <cjb@laptop.org>, Namjae Jeon <linkinjeon@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Add BOOT_PARTITION_ENABLE definition to MMC EXT_CSD PART_CONFIG
X-Enigmail-Version: 1.5.1
OpenPGP: id=1166F485
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bit mask for the BOOT_PARTITION_ENABLE values.

Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
---
 include/linux/mmc/mmc.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 50bcde3..eb5b361 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -347,6 +347,7 @@ struct _mmc_csd {
 #define EXT_CSD_PART_CONFIG_ACC_BOOT0    (0x1)
 #define EXT_CSD_PART_CONFIG_ACC_RPMB    (0x3)
 #define EXT_CSD_PART_CONFIG_ACC_GP0    (0x4)
+#define EXT_CSD_PART_CONFIG_EN_MASK    (0x38)
 
 #define EXT_CSD_PART_SUPPORT_PART_EN    (0x1)
 
-- 
1.7.0.4


