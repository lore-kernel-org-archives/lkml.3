Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaFERbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:31:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49315 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaFERbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:31:14 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 2/2] drm/msm: storage class should be before const qualifier
Date: Thu,  5 Jun 2014 18:30:58 +0100
Message-Id: <1401989458-450-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401989458-450-1-git-send-email-peter.griffin@linaro.org>
References: <1401989458-450-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/msm/msm_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index f9de156..407975d 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -159,7 +159,7 @@ static int msm_unload(struct drm_device *dev)
 static int get_mdp_ver(struct platform_device *pdev)
 {
 #ifdef CONFIG_OF
-	const static struct of_device_id match_types[] = { {
+	static const struct of_device_id match_types[] = { {
 		.compatible = "qcom,mdss_mdp",
 		.data	= (void	*)5,
 	}, {
-- 
1.9.1

