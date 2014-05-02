Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaEBPqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:46:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaEBPqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 124/151] drm/radeon: fix typo in spectre_golden_registers
Date: Fri,  2 May 2014 08:38:32 -0700
Message-Id: <1399045139-4531-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit f1553174a207f68a4ec19d436003097e0a4dc405 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index c46da97..e8b1ed8 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -1095,7 +1095,7 @@ static const u32 spectre_golden_registers[] =
 	0x8a14, 0xf000003f, 0x00000007,
 	0x8b24, 0xffffffff, 0x00ffffff,
 	0x28350, 0x3f3f3fff, 0x00000082,
-	0x28355, 0x0000003f, 0x00000000,
+	0x28354, 0x0000003f, 0x00000000,
 	0x3e78, 0x00000001, 0x00000002,
 	0x913c, 0xffff03df, 0x00000004,
 	0xc768, 0x00000008, 0x00000008,
-- 
1.9.1

