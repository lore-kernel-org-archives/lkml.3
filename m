Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502Ab3APQGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758484Ab3APQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Shiyan <shc_work@mail.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 145/222] irda: sir_dev: Fix copy/paste typo
Date: Wed, 16 Jan 2013 13:55:45 -0200
Message-Id: <1358351822-7675-146-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <shc_work@mail.ru>

commit 2355a62bcbdcc4b567425bab036bfab6ade87eed upstream.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/irda/sir_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/irda/sir_dev.c b/drivers/net/irda/sir_dev.c
index 5039f08..43e9ab4 100644
--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -222,7 +222,7 @@ static void sirdev_config_fsm(struct work_struct *work)
 			break;
 
 		case SIRDEV_STATE_DONGLE_SPEED:
-			if (dev->dongle_drv->reset) {
+			if (dev->dongle_drv->set_speed) {
 				ret = dev->dongle_drv->set_speed(dev, fsm->param);
 				if (ret < 0) {
 					fsm->result = ret;
-- 
1.7.9.5

