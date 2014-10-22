Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaJVJtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:49:25 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:57913 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaJVJs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:48:59 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH/TRIVIAL 1/5] drm/radeon: Spelling s/stucture/structure/
Date: Wed, 22 Oct 2014 11:48:59 +0200
Message-Id: <1413971343-27554-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/radeon/atombios.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index 92be50c39ffd4a4b..ab89eed9ddd9c47e 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -7944,8 +7944,8 @@ typedef struct {
 typedef struct {
   AMD_ACPI_DESCRIPTION_HEADER SHeader;
   UCHAR TableUUID[16];    //0x24
-  ULONG VBIOSImageOffset; //0x34. Offset to the first GOP_VBIOS_CONTENT block from the beginning of the stucture.
-  ULONG Lib1ImageOffset;  //0x38. Offset to the first GOP_LIB1_CONTENT block from the beginning of the stucture.
+  ULONG VBIOSImageOffset; //0x34. Offset to the first GOP_VBIOS_CONTENT block from the beginning of the structure.
+  ULONG Lib1ImageOffset;  //0x38. Offset to the first GOP_LIB1_CONTENT block from the beginning of the structure.
   ULONG Reserved[4];      //0x3C
 }UEFI_ACPI_VFCT;
 
-- 
1.9.1

