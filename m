Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaBMF2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:28:05 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48865 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaBMF2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:28:03 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/11] Input: synaptics-rmi4 - remove unused rmi_f01_remove()
Date: Wed, 12 Feb 2014 21:27:48 -0800
Message-Id: <1392269277-16391-2-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is an empty stub and is not needed.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_f01.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
index 92b90d1..897d8ac 100644
--- a/drivers/input/rmi4/rmi_f01.c
+++ b/drivers/input/rmi4/rmi_f01.c
@@ -451,11 +451,6 @@ static int rmi_f01_probe(struct rmi_function *fn)
 	return 0;
 }
 
-static void rmi_f01_remove(struct rmi_function *fn)
-{
-	/* Placeholder for now. */
-}
-
 #ifdef CONFIG_PM_SLEEP
 static int rmi_f01_suspend(struct device *dev)
 {
@@ -554,7 +549,6 @@ static struct rmi_function_handler rmi_f01_handler = {
 	},
 	.func		= 0x01,
 	.probe		= rmi_f01_probe,
-	.remove		= rmi_f01_remove,
 	.config		= rmi_f01_config,
 	.attention	= rmi_f01_attention,
 };
-- 
1.8.5.3

