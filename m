Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaINKaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:30:18 -0400
Received: from sender1.zohomail.com ([74.201.84.155]:30388 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaINKaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:30:16 -0400
From: Sorin Facaoaru <work@sorin.cc>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, sachin.kamat@linaro.org,
        kamlakant.patel@broadcom.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sorin Facaoaru <work@sorin.cc>
Subject: [PATCH] Staging: mt29f_spinand: fix coding style
Date: Sun, 14 Sep 2014 03:30:09 -0700
Message-Id: <1410690609-9870-1-git-send-email-work@sorin.cc>
X-Mailer: git-send-email 1.9.1
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_26084_0
X-ZohoMail-Owner: <1410690609-9870-1-git-send-email-work@sorin.cc>+zmo_0_<work@sorin.cc>
X-ZohoMail-Sender: 104.33.20.222
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add curly braces around else compound

Signed-off-by: Sorin Facaoaru <work@sorin.cc>
---
 drivers/staging/mt29f_spinand/mt29f_spinand.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/mt29f_spinand/mt29f_spinand.c b/drivers/staging/mt29f_spinand/mt29f_spinand.c
index 3464e0c..ccefbf8 100644
--- a/drivers/staging/mt29f_spinand/mt29f_spinand.c
+++ b/drivers/staging/mt29f_spinand/mt29f_spinand.c
@@ -279,8 +279,9 @@ static int spinand_disable_ecc(struct spi_device *spi_nand)
 		if (retval < 0)
 			return retval;
 		return spinand_get_otp(spi_nand, &otp);
-	} else
+	} else {
 		return 0;
+	}
 }
 
 /**
@@ -529,8 +530,9 @@ static int spinand_program_page(struct spi_device *spi_nand,
 				dev_err(&spi_nand->dev,
 					"program error, page %d\n", page_id);
 				return -1;
-			} else
+			} else {
 				break;
+			}
 		}
 	}
 #ifdef CONFIG_MTD_SPINAND_ONDIEECC
@@ -605,8 +607,9 @@ static int spinand_erase_block(struct spi_device *spi_nand, u16 block_id)
 				dev_err(&spi_nand->dev,
 					"erase error, block %d\n", block_id);
 				return -1;
-			} else
+			} else {
 				break;
+			}
 		}
 	}
 	return 0;
-- 
1.9.1


