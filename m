Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbaGOVjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:39:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55157 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934075AbaGOVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamlakant Patel <kamlakant.patel@broadcom.com>,
        Mona Anonuevo <manonuevo@micron.com>, linux-mtd@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 052/198] staging/mt29f_spinand: Terminate of match table
Date: Tue, 15 Jul 2014 14:28:42 -0700
Message-Id: <1405459868-15089-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit ffd07de65ef5315053ea16356cd533b7f47c17e9 upstream.

Failure to terminate this match table can lead to boot failures
depending on where the compiler places the match table.

Cc: Kamlakant Patel <kamlakant.patel@broadcom.com>
Cc: Mona Anonuevo <manonuevo@micron.com>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/mt29f_spinand/mt29f_spinand.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/mt29f_spinand/mt29f_spinand.c b/drivers/staging/mt29f_spinand/mt29f_spinand.c
index 51dbc13..5a40925 100644
--- a/drivers/staging/mt29f_spinand/mt29f_spinand.c
+++ b/drivers/staging/mt29f_spinand/mt29f_spinand.c
@@ -924,6 +924,7 @@ static int spinand_remove(struct spi_device *spi)
 
 static const struct of_device_id spinand_dt[] = {
 	{ .compatible = "spinand,mt29f", },
+	{}
 };
 
 /*
-- 
1.9.1

