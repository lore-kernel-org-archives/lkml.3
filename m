Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaAOWGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:06:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbaAOWA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:27 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Olof Johansson <olof@lixom.net>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 044/166] ARM: pxa: tosa: fix keys mapping
Date: Wed, 15 Jan 2014 13:50:58 -0800
Message-Id: <1389822780-4729-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

commit 506cac15ac86f204b83e3cfccde73eeb4e7c5f34 upstream.

When converting from tosa-keyboard driver to matrix keyboard, tosa keys
received extra 1 column shift. Replace that with correct values to make
keyboard work again.

Fixes: f69a6548c9d5 ('[ARM] pxa/tosa: make use of the matrix keypad driver')
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-pxa/tosa.c | 102 +++++++++++++++++++++++------------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
index 233629e..c7ff6d4 100644
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -424,57 +424,57 @@ static struct platform_device tosa_power_device = {
  * Tosa Keyboard
  */
 static const uint32_t tosakbd_keymap[] = {
-	KEY(0, 2, KEY_W),
-	KEY(0, 6, KEY_K),
-	KEY(0, 7, KEY_BACKSPACE),
-	KEY(0, 8, KEY_P),
-	KEY(1, 1, KEY_Q),
-	KEY(1, 2, KEY_E),
-	KEY(1, 3, KEY_T),
-	KEY(1, 4, KEY_Y),
-	KEY(1, 6, KEY_O),
-	KEY(1, 7, KEY_I),
-	KEY(1, 8, KEY_COMMA),
-	KEY(2, 1, KEY_A),
-	KEY(2, 2, KEY_D),
-	KEY(2, 3, KEY_G),
-	KEY(2, 4, KEY_U),
-	KEY(2, 6, KEY_L),
-	KEY(2, 7, KEY_ENTER),
-	KEY(2, 8, KEY_DOT),
-	KEY(3, 1, KEY_Z),
-	KEY(3, 2, KEY_C),
-	KEY(3, 3, KEY_V),
-	KEY(3, 4, KEY_J),
-	KEY(3, 5, TOSA_KEY_ADDRESSBOOK),
-	KEY(3, 6, TOSA_KEY_CANCEL),
-	KEY(3, 7, TOSA_KEY_CENTER),
-	KEY(3, 8, TOSA_KEY_OK),
-	KEY(3, 9, KEY_LEFTSHIFT),
-	KEY(4, 1, KEY_S),
-	KEY(4, 2, KEY_R),
-	KEY(4, 3, KEY_B),
-	KEY(4, 4, KEY_N),
-	KEY(4, 5, TOSA_KEY_CALENDAR),
-	KEY(4, 6, TOSA_KEY_HOMEPAGE),
-	KEY(4, 7, KEY_LEFTCTRL),
-	KEY(4, 8, TOSA_KEY_LIGHT),
-	KEY(4, 10, KEY_RIGHTSHIFT),
-	KEY(5, 1, KEY_TAB),
-	KEY(5, 2, KEY_SLASH),
-	KEY(5, 3, KEY_H),
-	KEY(5, 4, KEY_M),
-	KEY(5, 5, TOSA_KEY_MENU),
-	KEY(5, 7, KEY_UP),
-	KEY(5, 11, TOSA_KEY_FN),
-	KEY(6, 1, KEY_X),
-	KEY(6, 2, KEY_F),
-	KEY(6, 3, KEY_SPACE),
-	KEY(6, 4, KEY_APOSTROPHE),
-	KEY(6, 5, TOSA_KEY_MAIL),
-	KEY(6, 6, KEY_LEFT),
-	KEY(6, 7, KEY_DOWN),
-	KEY(6, 8, KEY_RIGHT),
+	KEY(0, 1, KEY_W),
+	KEY(0, 5, KEY_K),
+	KEY(0, 6, KEY_BACKSPACE),
+	KEY(0, 7, KEY_P),
+	KEY(1, 0, KEY_Q),
+	KEY(1, 1, KEY_E),
+	KEY(1, 2, KEY_T),
+	KEY(1, 3, KEY_Y),
+	KEY(1, 5, KEY_O),
+	KEY(1, 6, KEY_I),
+	KEY(1, 7, KEY_COMMA),
+	KEY(2, 0, KEY_A),
+	KEY(2, 1, KEY_D),
+	KEY(2, 2, KEY_G),
+	KEY(2, 3, KEY_U),
+	KEY(2, 5, KEY_L),
+	KEY(2, 6, KEY_ENTER),
+	KEY(2, 7, KEY_DOT),
+	KEY(3, 0, KEY_Z),
+	KEY(3, 1, KEY_C),
+	KEY(3, 2, KEY_V),
+	KEY(3, 3, KEY_J),
+	KEY(3, 4, TOSA_KEY_ADDRESSBOOK),
+	KEY(3, 5, TOSA_KEY_CANCEL),
+	KEY(3, 6, TOSA_KEY_CENTER),
+	KEY(3, 7, TOSA_KEY_OK),
+	KEY(3, 8, KEY_LEFTSHIFT),
+	KEY(4, 0, KEY_S),
+	KEY(4, 1, KEY_R),
+	KEY(4, 2, KEY_B),
+	KEY(4, 3, KEY_N),
+	KEY(4, 4, TOSA_KEY_CALENDAR),
+	KEY(4, 5, TOSA_KEY_HOMEPAGE),
+	KEY(4, 6, KEY_LEFTCTRL),
+	KEY(4, 7, TOSA_KEY_LIGHT),
+	KEY(4, 9, KEY_RIGHTSHIFT),
+	KEY(5, 0, KEY_TAB),
+	KEY(5, 1, KEY_SLASH),
+	KEY(5, 2, KEY_H),
+	KEY(5, 3, KEY_M),
+	KEY(5, 4, TOSA_KEY_MENU),
+	KEY(5, 6, KEY_UP),
+	KEY(5, 10, TOSA_KEY_FN),
+	KEY(6, 0, KEY_X),
+	KEY(6, 1, KEY_F),
+	KEY(6, 2, KEY_SPACE),
+	KEY(6, 3, KEY_APOSTROPHE),
+	KEY(6, 4, TOSA_KEY_MAIL),
+	KEY(6, 5, KEY_LEFT),
+	KEY(6, 6, KEY_DOWN),
+	KEY(6, 7, KEY_RIGHT),
 };
 
 static struct matrix_keymap_data tosakbd_keymap_data = {
-- 
1.8.3.2

