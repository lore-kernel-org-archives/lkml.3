Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3INES7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:18:59 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:61945 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3INES5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:18:57 -0400
Message-ID: <5233E393.5090109@huawei.com>
Date: Sat, 14 Sep 2013 12:18:27 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] i7core_edac: remove .c suffix from the mod name
References: <5233E216.3030506@huawei.com>
In-Reply-To: <5233E216.3030506@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found i7core_edac driver used 'xxx_edac.c' as mod name,
but others used 'xxx_edac'. So remove .c suffix.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/edac/i7core_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 80a963d..92f24e9 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -2233,7 +2233,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	mci->mtype_cap = MEM_FLAG_DDR3;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE;
 	mci->edac_cap = EDAC_FLAG_NONE;
-	mci->mod_name = "i7core_edac.c";
+	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I7CORE_REVISION;
 	mci->ctl_name = kasprintf(GFP_KERNEL, "i7 core #%d",
 				  i7core_dev->socket);
-- 
1.8.2.2


