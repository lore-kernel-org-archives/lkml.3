Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab3FEVxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:53:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab3FEVfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 070/127] drm/radeon: fix typo in cu_per_sh on verde
Date: Wed,  5 Jun 2013 14:33:57 -0700
Message-Id: <20130605213225.920789526@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 468ef1a58c9268ac9709350bf95eaf1c22a69f29 upstream.

Should be 5 rather than 2.

Noticed by sroland and glisse on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1645,7 +1645,7 @@ static void si_gpu_init(struct radeon_de
 	default:
 		rdev->config.si.max_shader_engines = 1;
 		rdev->config.si.max_tile_pipes = 4;
-		rdev->config.si.max_cu_per_sh = 2;
+		rdev->config.si.max_cu_per_sh = 5;
 		rdev->config.si.max_sh_per_se = 2;
 		rdev->config.si.max_backends_per_se = 4;
 		rdev->config.si.max_texture_channel_caches = 4;


