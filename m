Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaFEEhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:37:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaFEEVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 159/214] drm: fix documentation for drm_crtc_set_mode()
Date: Wed,  4 Jun 2014 21:18:42 -0700
Message-Id: <20140605041701.087475065@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4c9287c6009b37754c42e0ba73a4cc79de92d8f8 upstream.

x and y parameters are offsets, not width/height

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_crtc_helper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -328,8 +328,8 @@ drm_crtc_prepare_encoders(struct drm_dev
  * drm_crtc_set_mode - set a mode
  * @crtc: CRTC to program
  * @mode: mode to use
- * @x: width of mode
- * @y: height of mode
+ * @x: horizontal offset into the surface
+ * @y: vertical offset into the surface
  *
  * LOCKING:
  * Caller must hold mode config lock.


