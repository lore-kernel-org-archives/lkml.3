Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbaJIVLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:11:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845AbaJIVLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>, Dave Airlie <airlied@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 060/163] drm/ast: AST2000 cannot be detected correctly
Date: Thu,  9 Oct 2014 14:01:25 -0700
Message-Id: <1412888588-26755-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Y.C. Chen" <yc_chen@aspeedtech.com>

commit 83502a5d34386f7c6973bc70e1c423f55f5a2e3a upstream.

Type error and cause AST2000 cannot be detected correctly

Signed-off-by: Y.C. Chen <yc_chen@aspeedtech.com>
Reviewed-by: Egbert Eich <eich@suse.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ast/ast_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index df1266d..4e09386 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -101,7 +101,7 @@ static int ast_detect_chip(struct drm_device *dev)
 			}
 			ast->vga2_clone = false;
 		} else {
-			ast->chip = 2000;
+			ast->chip = AST2000;
 			DRM_INFO("AST 2000 detected\n");
 		}
 	}
-- 
1.9.1

