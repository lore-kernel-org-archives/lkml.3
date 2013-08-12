Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3HLXA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:00:26 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:12060 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HLXAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:00:24 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTy+fSJcJG
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/3] wistron_btns: mark the Medion MD96500 keymap as tested
Date: Tue, 13 Aug 2013 00:53:53 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-5.slh.2-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Miloslav Trmac <mitr@volny.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201308130050.52800.s.L-H@gmx.de>
In-Reply-To: <201308130050.52800.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308130053.59956.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMI: MEDIONPC WIM 2040/WIM 2040, BIOS R01-A0O    11/04/2005
wistron_btns: BIOS signature found at c00f6b00, entry point 000FDD50
input: Wistron laptop buttons as /devices/platform/wistron-bios/input/input5

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
 drivers/input/misc/wistron_btns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -562,7 +562,7 @@ static struct key_entry keymap_wistron_m
 	{ KE_KEY, 0x36, {KEY_WWW} },
 	{ KE_WIFI, 0x30 },
 	{ KE_BLUETOOTH, 0x44 },
-	{ KE_END, FE_UNTESTED }
+	{ KE_END, 0 }
 };
 
 static struct key_entry keymap_wistron_generic[] __initdata = {
