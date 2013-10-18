Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3JRTwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:52:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab3JRTwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:52:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        wojciech kapuscinski <wojtask9@wp.pl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 09/11] drm/radeon: fix hw contexts for SUMO2 asics
Date: Fri, 18 Oct 2013 12:53:38 -0700
Message-Id: <20131018195049.702863161@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131018195049.069623827@linuxfoundation.org>
References: <20131018195049.069623827@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1912,7 +1912,7 @@ static void evergreen_gpu_init(struct ra
 		rdev->config.evergreen.sx_max_export_size = 256;
 		rdev->config.evergreen.sx_max_export_pos_size = 64;
 		rdev->config.evergreen.sx_max_export_smx_size = 192;
-		rdev->config.evergreen.max_hw_contexts = 8;
+		rdev->config.evergreen.max_hw_contexts = 4;
 		rdev->config.evergreen.sq_num_cf_insts = 2;
 
 		rdev->config.evergreen.sc_prim_fifo_size = 0x40;


