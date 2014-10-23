Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaJWJxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:53:12 -0400
Received: from laurent.telenet-ops.be ([195.130.137.89]:33972 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaJWJw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:52:56 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-usb@vger.kernel.org
Subject: [PATCH/TRIVIAL 4/4] uwb: Remove bogus colon after newline from debug message
Date: Thu, 23 Oct 2014 11:52:57 +0200
Message-Id: <1414057977-4191-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414057977-4191-1-git-send-email-geert+renesas@glider.be>
References: <1414057977-4191-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-usb@vger.kernel.org
---
 drivers/uwb/rsv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uwb/rsv.c b/drivers/uwb/rsv.c
index 0887ae982783b7df..536ad42b0a4b1d7e 100644
--- a/drivers/uwb/rsv.c
+++ b/drivers/uwb/rsv.c
@@ -213,7 +213,7 @@ void uwb_rsv_backoff_win_timer(unsigned long arg)
 		bow->total_expired = 0;
 		bow->window = UWB_DRP_BACKOFF_WIN_MIN >> 1;
 	}
-	dev_dbg(dev, "backoff_win_timer total_expired=%d, n=%d\n: ", bow->total_expired, bow->n);
+	dev_dbg(dev, "backoff_win_timer total_expired=%d, n=%d\n", bow->total_expired, bow->n);
 
 	/* try to relocate all the "to be moved" relocations */
 	uwb_rsv_handle_drp_avail_change(rc);
@@ -234,7 +234,7 @@ void uwb_rsv_backoff_win_increment(struct uwb_rc *rc)
 
 	bow->window <<= 1;
 	bow->n = prandom_u32() & (bow->window - 1);
-	dev_dbg(dev, "new_window=%d, n=%d\n: ", bow->window, bow->n);
+	dev_dbg(dev, "new_window=%d, n=%d\n", bow->window, bow->n);
 
 	/* reset the timer associated variables */
 	timeout_us = bow->n * UWB_SUPERFRAME_LENGTH_US;
-- 
1.9.1

