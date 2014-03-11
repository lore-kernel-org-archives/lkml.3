Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaCKKYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:24:45 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:40860 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaCKKYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:24:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        wimax@linuxwimax.org
Subject: [PATCH trivial 13/16] wimax: Spelling s/than/that/, wording s/destinatary/recipient/
Date: Tue, 11 Mar 2014 11:23:47 +0100
Message-Id: <1394533430-4746-13-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: wimax@linuxwimax.org
---
 include/net/wimax.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/wimax.h b/include/net/wimax.h
index 98498e1daa06..e52ef5357e08 100644
--- a/include/net/wimax.h
+++ b/include/net/wimax.h
@@ -483,8 +483,8 @@ void wimax_report_rfkill_sw(struct wimax_dev *, enum wimax_rf_state);
  * Be sure not to modify skb->data in the middle (ie: don't use
  * skb_push()/skb_pull()/skb_reserve() on the skb).
  *
- * "pipe_name" is any string, than can be interpreted as the name of
- * the pipe or destinatary; the interpretation of it is driver
+ * "pipe_name" is any string, that can be interpreted as the name of
+ * the pipe or recipient; the interpretation of it is driver
  * specific, so the recipient can multiplex it as wished. It can be
  * NULL, it won't be used - an example is using a "diagnostics" tag to
  * send diagnostics information that a device-specific diagnostics
-- 
1.7.9.5

