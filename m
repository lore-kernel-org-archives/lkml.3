Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaJ2GgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:36:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbaJ2GgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:36:15 -0400
From: Masatake YAMATO <yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, yamato@redhat.com, taksato@redhat.com,
        yyamada@redhat.com
Subject: [PATCH] intel_ips: fix a type in error message
Date: Wed, 29 Oct 2014 15:35:54 +0900
Message-Id: <1414564554-7767-1-git-send-email-yamato@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 drivers/platform/x86/intel_ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index c0242ed..ecd36e3 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -593,7 +593,7 @@ static void ips_disable_gpu_turbo(struct ips_driver *ips)
 		return;
 
 	if (!ips->gpu_turbo_disable())
-		dev_err(&ips->dev->dev, "failed to disable graphis turbo\n");
+		dev_err(&ips->dev->dev, "failed to disable graphics turbo\n");
 	else
 		ips->__gpu_turbo_on = false;
 }
-- 
1.9.3

