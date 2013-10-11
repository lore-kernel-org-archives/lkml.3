Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3JKKnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:43:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58484 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab3JKKnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Vasut <marex@denx.de>, Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 031/100] video: mxsfb: Add missing break
Date: Fri, 11 Oct 2013 11:41:01 +0100
Message-Id: <1381488130-30235-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 6d0bb818041a02be682abadb3ba35ff608f7d60a upstream.

Add missing break into the restore function.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/mxsfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index fc2c4381..dc7b4fc 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -616,6 +616,7 @@ static int __devinit mxsfb_restore_mode(struct mxsfb_info *host)
 		break;
 	case 3:
 		bits_per_pixel = 32;
+		break;
 	case 1:
 	default:
 		return -EINVAL;
-- 
1.8.3.2

