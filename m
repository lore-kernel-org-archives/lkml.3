Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966735AbaCUBDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:03:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965363AbaCUAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 100/149] drm/radeon/dpm: fix typo in EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters
Date: Thu, 20 Mar 2014 17:04:23 -0700
Message-Id: <20140321000440.429454906@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 13714323f83ffa5a772fe0d8b74e0fa32ee08819 upstream.

Should be at 0x8 rather than 0.

fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60523

Noticed by ArtForz on #radeon

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen_smc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen_smc.h
+++ b/drivers/gpu/drm/radeon/evergreen_smc.h
@@ -57,7 +57,7 @@ typedef struct SMC_Evergreen_MCRegisters
 
 #define EVERGREEN_SMC_FIRMWARE_HEADER_LOCATION 0x100
 
-#define EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters   0x0
+#define EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters   0x8
 #define EVERGREEN_SMC_FIRMWARE_HEADER_stateTable      0xC
 #define EVERGREEN_SMC_FIRMWARE_HEADER_mcRegisterTable 0x20
 


