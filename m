Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab3EUCoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:44:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64992 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862Ab3EUCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:44:36 -0400
MIME-Version: 1.0
Date: Tue, 21 May 2013 10:44:34 +0800
Message-ID: <CAPgLHd_fTMMjPnE0fMc7fDMLuTmvQkPkW414Vya0-_whQf9Law@mail.gmail.com>
Subject: [PATCH -next] staging: btmtk_usb: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, acho@suse.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/btmtk_usb/btmtk_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/btmtk_usb/btmtk_usb.c b/drivers/staging/btmtk_usb/btmtk_usb.c
index 6b01f61..5d0a952 100644
--- a/drivers/staging/btmtk_usb/btmtk_usb.c
+++ b/drivers/staging/btmtk_usb/btmtk_usb.c
@@ -31,7 +31,6 @@
 #include <linux/completion.h>
 #include <linux/firmware.h>
 #include <linux/usb.h>
-#include <linux/version.h>
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 

