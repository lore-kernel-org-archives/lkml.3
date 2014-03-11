Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaCKKdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:33:44 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:52169 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbaCKKX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org
Subject: [PATCH trivial 04/16] of: Improve grammar for of_alias_get_id() documentation
Date: Tue, 11 Mar 2014 11:23:38 +0100
Message-Id: <1394533430-4746-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org
---
 drivers/of/base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 89e888a78899..5becd08651a7 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1871,8 +1871,8 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
  * @np:		Pointer to the given device_node
  * @stem:	Alias stem of the given device_node
  *
- * The function travels the lookup table to get alias id for the given
- * device_node and alias stem.  It returns the alias id if find it.
+ * The function travels the lookup table to get the alias id for the given
+ * device_node and alias stem.  It returns the alias id if found.
  */
 int of_alias_get_id(struct device_node *np, const char *stem)
 {
-- 
1.7.9.5

