Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935060Ab3JPSVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:21:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761310Ab3JPRpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        wojciech kapuscinski <wojtask9@wp.pl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 29/69] drm/radeon: fix hw contexts for SUMO2 asics
Date: Wed, 16 Oct 2013 10:44:38 -0700
Message-Id: <20131016174316.451115329@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wojciech kapuscinski <wojtask9@wp.pl>

commit 50b8f5aec04ebec7dbdf2adb17220b9148c99e63 upstream.

They have 4 rather than 8.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=63599

Signed-off-by: wojciech kapuscinski <wojtask9@wp.pl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2990,7 +2990,7 @@ static void evergreen_gpu_init(struct ra
 		rdev->config.evergreen.sx_max_export_size = 256;
 		rdev->config.evergreen.sx_max_export_pos_size = 64;
 		rdev->config.evergreen.sx_max_export_smx_size = 192;
-		rdev->config.evergreen.max_hw_contexts = 8;
+		rdev->config.evergreen.max_hw_contexts = 4;
 		rdev->config.evergreen.sq_num_cf_insts = 2;
 
 		rdev->config.evergreen.sc_prim_fifo_size = 0x40;


