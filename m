Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaDDRN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:13:27 -0400
Received: from smtp04.udag.de ([62.146.106.30]:34911 "EHLO smtp04.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbaDDRNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:13:25 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Apr 2014 13:13:25 EDT
From: Tolga Cakir <tolga@cevel.net>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Derya <derya.kiran@yahoo.de>, Jiri Kosina <jkosina@suse.cz>,
        Reyad Attiyat <reyad.attiyat@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tolga Cakir <tolga@cevel.net>
Subject: [PATCH 4/4] HID: microsoft: undefining ms_map_key_clear after usage
Date: Fri,  4 Apr 2014 19:07:17 +0200
Message-Id: <1396631237-11813-1-git-send-email-tolga@cevel.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is inspired by various other hid drivers.

Signed-off-by: Tolga Cakir <tolga@cevel.net>
---
 drivers/hid/hid-microsoft.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 5674c0c..5281d2d 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -211,6 +211,8 @@ static int ms_sidewinder_kb_quirk(struct hid_input *hi, struct hid_usage *usage,
 	return 1;
 }
 
+#undef ms_map_key_clear
+
 static int ms_sidewinder_control(struct hid_device *hdev, __u8 setup)
 {
 	struct ms_data *sc = hid_get_drvdata(hdev);
-- 
1.9.1

