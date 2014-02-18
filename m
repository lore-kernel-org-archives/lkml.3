Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaBRNvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:51:15 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:48413 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaBRNuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:50:08 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1IDo6uj029721, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 13/14] r8152: set disable_hub_initiated_lpm
Date: Tue, 18 Feb 2014 21:49:10 +0800
Message-ID: <1392731351-25502-14-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
References: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set disable_hub_initiated_lpm = 1.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ff02d5d..db98842 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3159,6 +3159,7 @@ static struct usb_driver rtl8152_driver = {
 	.resume =	rtl8152_resume,
 	.reset_resume =	rtl8152_resume,
 	.supports_autosuspend = 1,
+	.disable_hub_initiated_lpm = 1,
 };
 
 module_usb_driver(rtl8152_driver);
-- 
1.8.4.2

