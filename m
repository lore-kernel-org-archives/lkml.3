Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab3EIWq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:46:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab3EIWdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 60/73] drm/radeon: fix typo in si_select_se_sh()
Date: Thu,  9 May 2013 15:32:23 -0700
Message-Id: <20130509222804.411381181@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 79b52d6a7085a3e430c6de450a5847fdbe04159b upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1374,7 +1374,7 @@ static void si_select_se_sh(struct radeo
 	u32 data = INSTANCE_BROADCAST_WRITES;
 
 	if ((se_num == 0xffffffff) && (sh_num == 0xffffffff))
-		data = SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
+		data |= SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
 	else if (se_num == 0xffffffff)
 		data |= SE_BROADCAST_WRITES | SH_INDEX(sh_num);
 	else if (sh_num == 0xffffffff)


