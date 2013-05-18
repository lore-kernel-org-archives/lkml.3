Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab3ERDSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:18:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab3ERDAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:11 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PSthegZ-r54A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=w9FeSK3r1J4A:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=QvMga0s8AAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=ISA-fX4Z5lwA:10 a=YNILnfeCTXOyh1FM:21 a=sOagY3BGneaZZRxT:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021701.958986300@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 127/136 ] drm/radeon: fix typo in si_select_se_sh()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0127-drm-radeon-fix-typo-in-si_select_se_sh.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 79b52d6a7085a3e430c6de450a5847fdbe04159b ]

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/si.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 992e60c..f2b256c 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1374,7 +1374,7 @@ static void si_select_se_sh(struct radeon_device *rdev,
 	u32 data = INSTANCE_BROADCAST_WRITES;
 
 	if ((se_num == 0xffffffff) && (sh_num == 0xffffffff))
-		data = SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
+		data |= SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
 	else if (se_num == 0xffffffff)
 		data |= SE_BROADCAST_WRITES | SH_INDEX(sh_num);
 	else if (sh_num == 0xffffffff)
-- 
1.7.10.4


