Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaAFGjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:39:44 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:43071 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaAFGjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:39:41 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s066dc9C018993, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/3] r8152: replace some tabs with spaces
Date: Mon, 6 Jan 2014 14:39:24 +0800
Message-ID: <1388990366-8508-2-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388990366-8508-1-git-send-email-hayeswang@realtek.com>
References: <1388990366-8508-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the tabs of the variables declaration with the spaces.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 13fabbb..095f15b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -584,8 +584,8 @@ int set_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
 static int generic_ocp_read(struct r8152 *tp, u16 index, u16 size,
 				void *data, u16 type)
 {
-	u16	limit = 64;
-	int	ret = 0;
+	u16 limit = 64;
+	int ret = 0;
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return -ENODEV;
@@ -624,9 +624,9 @@ static int generic_ocp_read(struct r8152 *tp, u16 index, u16 size,
 static int generic_ocp_write(struct r8152 *tp, u16 index, u16 byteen,
 				u16 size, void *data, u16 type)
 {
-	int	ret;
-	u16	byteen_start, byteen_end, byen;
-	u16	limit = 512;
+	int ret;
+	u16 byteen_start, byteen_end, byen;
+	u16 limit = 512;
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return -ENODEV;
@@ -1812,8 +1812,8 @@ static void r8152b_exit_oob(struct r8152 *tp)
 
 static void r8152b_enter_oob(struct r8152 *tp)
 {
-	u32	ocp_data;
-	int	i;
+	u32 ocp_data;
+	int i;
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
@@ -2340,7 +2340,7 @@ static void r8153_clear_bp(struct r8152 *tp)
 
 static void r8152b_enable_eee(struct r8152 *tp)
 {
-	u32	ocp_data;
+	u32 ocp_data;
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
 	ocp_data |= EEE_RX_EN | EEE_TX_EN;
-- 
1.8.4.2

