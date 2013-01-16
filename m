Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3APQAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:00:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35835 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3APQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 043/222] mfd: wm8994: Add support for WM1811 rev E
Date: Wed, 16 Jan 2013 13:54:03 -0200
Message-Id: <1358351822-7675-44-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit fee546ce8cfd9dea1f53175f627e17ef5ff05df4 upstream.

This is supported identically to the previous revisions.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mfd/wm8994-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 1e321d3..3e6fbae 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -542,6 +542,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		case 1:
 		case 2:
 		case 3:
+		case 4:
 			regmap_patch = wm1811_reva_patch;
 			patch_regs = ARRAY_SIZE(wm1811_reva_patch);
 			break;
-- 
1.7.9.5

