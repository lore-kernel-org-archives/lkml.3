Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaDVQiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:38:22 -0400
Received: from relmlor3.renesas.com ([210.160.252.173]:40358 "EHLO
	relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757316AbaDVQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:38:19 -0400
X-IronPort-AV: E=Sophos;i="4.97,904,1389711600"; 
   d="scan'208";a="159405843"
From: Phil Edworthy <phil.edworthy@renesas.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Phil Edworthy <phil.edworthy@renesas.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-SH <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
X-Mailer: git-send-email 1.9.1
X-TNEFEvaluated: 1
Message-ID: <1398184685-31670-1-git-send-email-phil.edworthy@renesas.com>
Date: Tue, 22 Apr 2014 17:38:05 +0100
Subject: [PATCH] sh-pfc: r8a7791: Fix definition of MOD_SEL3
X-MIMETrack: Itemize by SMTP Server on DU0NOTES13/SERVER/REE(Release 8.5.3 HF466|March
 09, 2012) at 22.04.2014 18:38:11,
	Serialize by Router on DU0NOTES13/SERVER/REE(Release 8.5.3 HF466|March 09, 2012) at
 22.04.2014 18:38:13,
	Serialize complete at 22.04.2014 18:38:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a missing 0 entry from the MOD_SEL3 table.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
index 56f62dc..a823b5b 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
@@ -5305,7 +5305,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 		/* SEL_SCIF3 [2] */
 		FN_SEL_SCIF3_0, FN_SEL_SCIF3_1, FN_SEL_SCIF3_2, FN_SEL_SCIF3_3,
 		/* SEL_IEB [2] */
-		FN_SEL_IEB_0, FN_SEL_IEB_1, FN_SEL_IEB_2,
+		FN_SEL_IEB_0, FN_SEL_IEB_1, FN_SEL_IEB_2, 0,
 		/* SEL_MMC [1] */
 		FN_SEL_MMC_0, FN_SEL_MMC_1,
 		/* SEL_SCIF5 [1] */
-- 
1.9.1

