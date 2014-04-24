Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaDXJqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:46:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46827 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbaDXIzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 121/182] drm/radeon: fix typo in spectre_golden_registers
Date: Thu, 24 Apr 2014 09:50:46 +0100
Message-Id: <1398329507-5911-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit f1553174a207f68a4ec19d436003097e0a4dc405 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 7ab8bdc..bf96acf 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -271,7 +271,7 @@ static const u32 spectre_golden_registers[] =
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

