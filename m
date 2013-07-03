Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149Ab3GCTBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:01:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23390 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067Ab3GCTAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:35 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=s5qreGecmOQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OM1SSI8M7ScA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184050.574643350@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [036/141] drm/radeon: fix typo in cu_per_sh on verde
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0036-drm-radeon-fix-typo-in-cu_per_sh-on-verde.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 468ef1a58c9268ac9709350bf95eaf1c22a69f29 ]

Should be 5 rather than 2.

Noticed by sroland and glisse on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/si.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 7d0026b..2fa541c 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1556,7 +1556,7 @@ static void si_gpu_init(struct radeon_device *rdev)
 	default:
 		rdev->config.si.max_shader_engines = 1;
 		rdev->config.si.max_tile_pipes = 4;
-		rdev->config.si.max_cu_per_sh = 2;
+		rdev->config.si.max_cu_per_sh = 5;
 		rdev->config.si.max_sh_per_se = 2;
 		rdev->config.si.max_backends_per_se = 4;
 		rdev->config.si.max_texture_channel_caches = 4;
-- 
1.7.10.4


