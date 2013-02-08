Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772Ab3BHBIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:08:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759609Ab3BHA6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 03/26] drm/radeon: add WAIT_UNTIL to the non-VM safe regs list for cayman/TN
Date: Thu,  7 Feb 2013 16:57:31 -0800
Message-Id: <20130208004627.825523324@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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


