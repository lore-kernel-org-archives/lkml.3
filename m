Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3EUCnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:43:04 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32485 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686Ab3EUCnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:43:01 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <akpm@linux-foundation.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 11/19] drivers/net/ethernet/natsemi: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:32 +0800
Message-ID: <1369104152-20152-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set the owner of platform_driver, to ensure that the
caller of driver holds a module refernece

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/natsemi/xtsonic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
index c2e0256..9281781 100644
--- a/drivers/net/ethernet/natsemi/xtsonic.c
+++ b/drivers/net/ethernet/natsemi/xtsonic.c
@@ -315,6 +315,7 @@ static struct platform_driver xtsonic_driver = {
 	.remove = xtsonic_device_remove,
 	.driver = {
 		.name = xtsonic_string,
+		.owner	= THIS_MODULE,
 	},
 };
 
-- 
1.7.1


