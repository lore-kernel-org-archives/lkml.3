Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873AbaE2OLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:11:06 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59401 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933263AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 056/103] drm/radeon: fix typo in spectre_golden_registers
Date: Thu, 29 May 2014 15:48:41 +0200
Message-Id: <946a34f2de502fd9b29871f41903c2197fc81733.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f1553174a207f68a4ec19d436003097e0a4dc405 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/cik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 25370ac56b4b..bcefa1de3e97 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -1092,7 +1092,7 @@ static const u32 spectre_golden_registers[] =
 	0x8a14, 0xf000003f, 0x00000007,
 	0x8b24, 0xffffffff, 0x00ffffff,
 	0x28350, 0x3f3f3fff, 0x00000082,
-	0x28355, 0x0000003f, 0x00000000,
+	0x28354, 0x0000003f, 0x00000000,
 	0x3e78, 0x00000001, 0x00000002,
 	0x913c, 0xffff03df, 0x00000004,
 	0xc768, 0x00000008, 0x00000008,
-- 
1.9.3

