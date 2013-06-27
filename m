Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3F0NA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:00:59 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:5085 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab3F0M7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:59:48 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Michael Buesch <m@bues.ch>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jiri Kosina <trivial@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 5/6] Gpio/trivial: replace numeric with standard PM state macros
Date: Thu, 27 Jun 2013 20:58:55 +0800
Message-ID: <1372337935-28772-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard PM state macros PCI_Dx instead of numeric 0/1/2..

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Michael Buesch <m@bues.ch>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpio/gpio-bt8xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
index 7d9d7cb..8369e71 100644
--- a/drivers/gpio/gpio-bt8xx.c
+++ b/drivers/gpio/gpio-bt8xx.c
@@ -286,7 +286,7 @@ static int bt8xxgpio_resume(struct pci_dev *pdev)
 	unsigned long flags;
 	int err;
 
-	pci_set_power_state(pdev, 0);
+	pci_set_power_state(pdev, PCI_D0);
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
-- 
1.7.1


