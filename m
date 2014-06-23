Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaFWNga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:36:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36720 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaFWNDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 14/93] drm/radeon: fix register typo on si
Date: Mon, 23 Jun 2014 14:01:53 +0100
Message-Id: <1403528592-2163-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 4955bb073f1be6dd884b5d10041ba4bade6495bf upstream.

Probably a copy paste typo.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/sid.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 0b55877c26b4..ff027425fe98 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -102,8 +102,8 @@
 #define	CG_SPLL_FUNC_CNTL_4				0x60c
 
 #define	SPLL_CNTL_MODE					0x618
-#	define SPLL_REFCLK_SEL(x)			((x) << 8)
-#	define SPLL_REFCLK_SEL_MASK			0xFF00
+#	define SPLL_REFCLK_SEL(x)			((x) << 26)
+#	define SPLL_REFCLK_SEL_MASK			(3 << 26)
 
 #define	CG_SPLL_SPREAD_SPECTRUM				0x620
 #define		SSEN					(1 << 0)
-- 
1.9.1

