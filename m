Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3LBTuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:50:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3LBTSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 133/212] drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL
Date: Mon,  2 Dec 2013 11:15:24 -0800
Message-Id: <20131202191301.800500639@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d5693761b2b4ff530c8af8af9ec55b6eae76e617 upstream.

Typo in the register offset.

Noticed-by: Sylvain BERTRAND <sylware@legeek.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/sid.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -478,7 +478,7 @@
 #define		STATE3_MASK				(0x1f << 15)
 #define		STATE3_SHIFT				15
 
-#define	MC_SEQ_TRAIN_WAKEUP_CNTL			0x2808
+#define	MC_SEQ_TRAIN_WAKEUP_CNTL			0x28e8
 #define		TRAIN_DONE_D0      			(1 << 30)
 #define		TRAIN_DONE_D1      			(1 << 31)
 


