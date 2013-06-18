Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3FRD7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:59:25 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:39545 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206Ab3FRD7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:59:24 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <dmitry.torokhov@gmail.com>, <arnd@arndb.de>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <drwyrm@gmail.com>, <stefan@openezx.org>,
        <laforge@openezx.org>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <sleep_walker@suse.cz>, <slapin@ossfans.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V3 4/5] input: pxa27x-keypad: remove the unused members at platform data
Date: Mon, 17 Jun 2013 23:56:17 -0400
Message-ID: <1371527778-5236-5-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
References: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now pxa27x-keypad make use matrix_keymap for matrix keyes, so
remove the unused members in platform data.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 include/linux/platform_data/keypad-pxa27x.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/platform_data/keypad-pxa27x.h b/include/linux/platform_data/keypad-pxa27x.h
index 0db423b..2462556 100644
--- a/include/linux/platform_data/keypad-pxa27x.h
+++ b/include/linux/platform_data/keypad-pxa27x.h
@@ -39,8 +39,6 @@ struct pxa27x_keypad_platform_data {
 	const struct matrix_keymap_data *matrix_keymap_data;
 	unsigned int	matrix_key_rows;
 	unsigned int	matrix_key_cols;
-	unsigned int	*matrix_key_map;
-	int		matrix_key_map_size;
 
 	/* direct keys */
 	int		direct_key_num;
-- 
1.7.4.1

