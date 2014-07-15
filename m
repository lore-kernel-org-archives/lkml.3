Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbaGOTej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbaGOTee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:34:34 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 02/23] Input - wacom: assign phys field from struct wacom into input_dev
Date: Tue, 15 Jul 2014 14:45:25 -0400
Message-Id: <1405449946-11515-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field was not used for 9 years, it is time to assign it.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

no changes in v2

 drivers/input/tablet/wacom_sys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 72b1724..7cd0886 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -1127,6 +1127,7 @@ static int wacom_register_input(struct wacom *wacom)
 	}
 
 	input_dev->name = wacom_wac->name;
+	input_dev->phys = wacom->phys;
 	input_dev->dev.parent = &intf->dev;
 	input_dev->open = wacom_open;
 	input_dev->close = wacom_close;
-- 
2.0.0

