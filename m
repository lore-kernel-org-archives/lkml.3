Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaBUMHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:07:46 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40825 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaBUMHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:07:43 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LMML <linux-media@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/3] media: omap3isp: ispccdc: remove unwanted comments
Date: Fri, 21 Feb 2014 17:37:22 +0530
Message-Id: <1392984443-16694-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392984443-16694-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1392984443-16694-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch removes the description of members which
does not exists for ispccdc_lsc structure.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/omap3isp/ispccdc.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.h b/drivers/media/platform/omap3isp/ispccdc.h
index a5da9e1..9d24e41 100644
--- a/drivers/media/platform/omap3isp/ispccdc.h
+++ b/drivers/media/platform/omap3isp/ispccdc.h
@@ -63,12 +63,6 @@ struct ispccdc_lsc_config_req {
 
 /*
  * ispccdc_lsc - CCDC LSC parameters
- * @update_config: Set when user changes config
- * @request_enable: Whether LSC is requested to be enabled
- * @config: LSC config set by user
- * @update_table: Set when user provides a new LSC table to table_new
- * @table_new: LSC table set by user, ISP address
- * @table_inuse: LSC table currently in use, ISP address
  */
 struct ispccdc_lsc {
 	enum ispccdc_lsc_state state;
-- 
1.7.9.5

