Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3HLWu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:50:59 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:17316 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3HLWu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:50:57 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTy+fSJcJG
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/3] wistron_btns: drop bogus MODULE_VERSION macro
Date: Tue, 13 Aug 2013 00:50:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-5.slh.2-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Miloslav Trmac <mitr@volny.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308130050.52800.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MODULE_VERSION is pointless for an in-kernel module and git log confirms that
it has never been actually maintained as well (bumped a single time, despite 
quite major feature additions later on, which haven't been reflected in
MODULE_VERSION).

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
 drivers/input/misc/wistron_btns.c | 1 -
 1 file changed, 1 deletion(-)

--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -46,7 +46,6 @@
 MODULE_AUTHOR("Miloslav Trmac <mitr@volny.cz>");
 MODULE_DESCRIPTION("Wistron laptop button driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION("0.3");
 
 static bool force; /* = 0; */
 module_param(force, bool, 0);
