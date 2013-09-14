Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3INEPD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:15:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:46322 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3INEPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:15:01 -0400
Message-ID: <5233E29F.9000804@huawei.com>
Date: Sat, 14 Sep 2013 12:14:23 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] i5000_edac: remove .c suffix from the mod name
References: <5233E216.3030506@huawei.com>
In-Reply-To: <5233E216.3030506@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found i5000_edac driver used 'xxx_edac.c' as mod name,
but others used 'xxx_edac'. So remove .c suffix.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/edac/i5000_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 63b2194..1a649c8 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1429,7 +1429,7 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->mtype_cap = MEM_FLAG_FB_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE;
 	mci->edac_cap = EDAC_FLAG_NONE;
-	mci->mod_name = "i5000_edac.c";
+	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I5000_REVISION;
 	mci->ctl_name = i5000_devs[dev_idx].ctl_name;
 	mci->dev_name = pci_name(pdev);
-- 
1.8.2.2


