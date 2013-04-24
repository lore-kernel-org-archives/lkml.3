Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab3DXD0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:26:03 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50445 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757400Ab3DXDZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:25:59 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>, <haojian.zhuang@gmail.com>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 5/6] input: pxa27x-keypad: remove the unused members at platform data
Date: Tue, 23 Apr 2013 23:20:32 -0400
Message-ID: <1366773633-7727-6-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366773633-7727-1-git-send-email-chao.xie@marvell.com>
References: <1366773633-7727-1-git-send-email-chao.xie@marvell.com>
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

