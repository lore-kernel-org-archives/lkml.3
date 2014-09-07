Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaIGOOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 10:14:10 -0400
Received: from mx02.posteo.de ([89.146.194.165]:38025 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbaIGOOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 10:14:08 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] rtl8192u: remove typedef
Date: Sun,  7 Sep 2014 16:12:30 +0200
Message-Id: <1410099150-11637-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove a typedef that is not even really used.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
builds in next-20140905.

 drivers/staging/rtl8192u/r8192U_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 3707d03..a4e1d6b 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -137,12 +137,12 @@ static struct usb_driver rtl8192_usb_driver = {
 };
 
 
-typedef struct _CHANNEL_LIST {
+struct CHANNEL_LIST {
 	u8	Channel[32];
 	u8	Len;
-} CHANNEL_LIST, *PCHANNEL_LIST;
+};
 
-static CHANNEL_LIST ChannelPlan[] = {
+static struct CHANNEL_LIST ChannelPlan[] = {
 	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165}, 24},		//FCC
 	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},							//IC
 	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	//ETSI
-- 
1.7.10.4

