Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3BHBSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:18:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab3BHA5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 04/34] drm/radeon: add WAIT_UNTIL to the non-VM safe regs list for cayman/TN
Date: Thu,  7 Feb 2013 16:57:00 -0800
Message-Id: <20130208004628.139604655@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 674a16f2b4724880d07389abbb95abf320b924aa upstream.

Newer versions of mesa emit this.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/reg_srcs/cayman |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/reg_srcs/cayman
+++ b/drivers/gpu/drm/radeon/reg_srcs/cayman
@@ -1,5 +1,6 @@
 cayman 0x9400
 0x0000802C GRBM_GFX_INDEX
+0x00008040 WAIT_UNTIL
 0x000084FC CP_STRMOUT_CNTL
 0x000085F0 CP_COHER_CNTL
 0x000085F4 CP_COHER_SIZE


