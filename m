Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaLVUZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:25:54 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45763 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaLVUZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:25:52 -0500
From: Jim Davis <jim.epost@gmail.com>
To: mchehab@osg.samsung.com, gregkh@linuxfoundation.org, shijie8@gmail.com,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Jim Davis <jim.epost@gmail.com>
Subject: [PATCH] media: tlg2300: disable building the driver
Date: Mon, 22 Dec 2014 13:25:45 -0700
Message-Id: <1419279945-16777-1-git-send-email-jim.epost@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver doesn't build with the current kernel, as reported in
linux-next (https://lkml.org/lkml/2014/12/18/483) and by the 0-day
build system
(https://www.mail-archive.com/linux-media@vger.kernel.org/msg83501.html).
Since it's scheduled for removal, disable building it for now.

Signed-off-by: Jim Davis <jim.epost@gmail.com>
---
 drivers/staging/media/tlg2300/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/tlg2300/Kconfig b/drivers/staging/media/tlg2300/Kconfig
index 81784c6f7b88..87181b0f77fd 100644
--- a/drivers/staging/media/tlg2300/Kconfig
+++ b/drivers/staging/media/tlg2300/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_TLG2300
 	select VIDEOBUF_VMALLOC
 	select SND_PCM
 	select VIDEOBUF_DVB
+	depends on BROKEN

 	---help---
 	  This is a video4linux driver for Telegent tlg2300 based TV cards.
-- 
2.1.1

