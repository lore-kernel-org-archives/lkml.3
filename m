Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbaGHBHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:07:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaGGXx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.15 033/122] drm/radeon: add missing vce init case for hawaii
Date: Mon,  7 Jul 2014 16:56:35 -0700
Message-Id: <20140707235735.240924024@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d71c48f69cc03912578472bced4cc43069fe07e1 upstream.

Hawaii has the same version of VCE as other CIK parts.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_vce.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_vce.c
+++ b/drivers/gpu/drm/radeon/radeon_vce.c
@@ -66,6 +66,7 @@ int radeon_vce_init(struct radeon_device
 	case CHIP_BONAIRE:
 	case CHIP_KAVERI:
 	case CHIP_KABINI:
+	case CHIP_HAWAII:
 	case CHIP_MULLINS:
 		fw_name = FIRMWARE_BONAIRE;
 		break;


