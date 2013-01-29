Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3A2CAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:00:19 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:53188 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483Ab3A2B7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:59:05 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 2/6] staging/fwserial: Refer to fw_device as "node"
Date: Mon, 28 Jan 2013 20:57:45 -0500
Message-Id: <1359424669-5723-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359424669-5723-1-git-send-email-peter@hurleysoftware.com>
References: <20130107232206.GA15244@kroah.com>
 <1359424669-5723-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 233bb56..ae180a3 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -174,7 +174,7 @@ static void dump_profile(struct seq_file *m, struct stats *stats)
 #define dump_profile(m, stats)
 #endif
 
-/* Returns the max receive packet size for the given card */
+/* Returns the max receive packet size for the given node */
 static inline int device_max_receive(struct fw_device *fw_device)
 {
 	return 1 <<  (clamp_t(int, fw_device->max_rec, 8U, 11U) + 1);
-- 
1.8.1.1

