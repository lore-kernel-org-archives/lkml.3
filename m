Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaHTNoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:44:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36203 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaHTNoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:01 -0400
X-AuditID: cbfee61a-f79e46d00000134f-b7-53f4a61f41fe
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH/RFC v5 1/3] mfd: max77693: Fix register enum name
Date: Wed, 20 Aug 2014 15:43:39 +0200
Message-id: <1408542221-375-2-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jQV35ZV+CDY7us7TYOGM9q8X8I+dY
	LT7e+8dq0Xv1OaPF2aY37Bb3vx5ltLi8aw6bxdY36xgtejZsZbU43c3qwOVx59oeNo95JwM9
	+rasYvR49vEds8fnTXIBrFFcNimpOZllqUX6dglcGV9eXmEseMRese7caeYGxrNsXYycHBIC
	JhLz+pawQNhiEhfurQeKc3EICUxnlJi27y47hNPOJDG3dSUrSBWbgKHEzxevmUBsEYFyiZ73
	z8A6mAWuM0o8mXSEGSQhLOAo0b62kR3EZhFQldiwZAFYA6+Am8TE25OA4hxA6xQk5kyyAQlz
	CrhLnO04CtYqBFRyv3kT0wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxggPumdQO
	xpUNFocYBTgYlXh4GxZ8CRZiTSwrrsw9xCjBwawkwtveCRTiTUmsrEotyo8vKs1JLT7EKM3B
	oiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAaHz+1l2NjUs+vDn8v3Z2wAbuikcuO5fJJjx+
	sHLCmtXzeQ76fp203aHgQ5LGdwuRc/+6L+zcPf/0wqdLZiSkx8yYOFFq3eul94+ViIZPk5h3
	ePIC1RlLz/u9v+OpZJi5pPDGtj/23FVsJ5vfdsTmfX32p3TPFk+Hz4X1iV1/dtj+a4vUvPL8
	T1ObEktxRqKhFnNRcSIAEZXLcTQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the MAX77693 documentation the name of
the register is FLASH_STATUS.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: SangYoung Son <hello.son@smasung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/mfd/max77693-private.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index c466ff3..615f121 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -46,7 +46,7 @@ enum max77693_pmic_reg {
 	MAX77693_LED_REG_VOUT_FLASH2			= 0x0C,
 	MAX77693_LED_REG_FLASH_INT			= 0x0E,
 	MAX77693_LED_REG_FLASH_INT_MASK			= 0x0F,
-	MAX77693_LED_REG_FLASH_INT_STATUS		= 0x10,
+	MAX77693_LED_REG_FLASH_STATUS			= 0x10,
 
 	MAX77693_PMIC_REG_PMIC_ID1			= 0x20,
 	MAX77693_PMIC_REG_PMIC_ID2			= 0x21,
-- 
1.7.9.5

