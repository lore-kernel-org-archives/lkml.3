Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaJCVdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:33:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaJCVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:33:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, Egbert Eich <eich@suse.de>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.16 081/357] drm/ast: AST2000 cannot be detected correctly
Date: Fri,  3 Oct 2014 14:27:47 -0700
Message-Id: <20141003212935.919259931@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Y.C. Chen" <yc_chen@aspeedtech.com>

commit 83502a5d34386f7c6973bc70e1c423f55f5a2e3a upstream.

Type error and cause AST2000 cannot be detected correctly

Signed-off-by: Y.C. Chen <yc_chen@aspeedtech.com>
Reviewed-by: Egbert Eich <eich@suse.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ast/ast_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -105,7 +105,7 @@ static int ast_detect_chip(struct drm_de
 			}
 			ast->vga2_clone = false;
 		} else {
-			ast->chip = 2000;
+			ast->chip = AST2000;
 			DRM_INFO("AST 2000 detected\n");
 		}
 	}


