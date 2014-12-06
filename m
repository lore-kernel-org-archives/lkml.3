Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaLFPU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:27 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47660 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752116AbaLFPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 08/66] Input: synaptics - add min/max quirk for pnp-id LEN2002 (Edge E531)
Date: Sat,  6 Dec 2014 16:07:00 +0100
Message-Id: <f24045932464431eb19b346924212657b0125220.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e76aed9da7189eeb41b9856552ce5721181e8e8d upstream.

https://bugzilla.redhat.com/show_bug.cgi?id=1114768

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/synaptics.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index d4d46d2bbe5d..a50a2a7a43f7 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -132,7 +132,8 @@ static const struct min_max_quirk min_max_pnpid_table[] = {
 		1232, 5710, 1156, 4696
 	},
 	{
-		(const char * const []){"LEN0034", "LEN0036", "LEN2004", NULL},
+		(const char * const []){"LEN0034", "LEN0036", "LEN2002",
+					"LEN2004", NULL},
 		1024, 5112, 2024, 4832
 	},
 	{
@@ -168,7 +169,7 @@ static const char * const topbuttonpad_pnp_ids[] = {
 	"LEN0049",
 	"LEN2000",
 	"LEN2001", /* Edge E431 */
-	"LEN2002",
+	"LEN2002", /* Edge E531 */
 	"LEN2003",
 	"LEN2004", /* L440 */
 	"LEN2005",
-- 
2.1.3

