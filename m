Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3CZX3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:29:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3CZWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 61/98] drm/radeon: add support for Richland APUs
Date: Tue, 26 Mar 2013 15:42:50 -0700
Message-Id: <20130326224248.847750922@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e4d170633fde379f39a90f8a5e7eb619b5d1144d upstream.

Richland APUs are a new version of the Trinity APUs
with performance and power management improvements.

Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -466,13 +466,19 @@ static void cayman_gpu_init(struct radeo
 		    (rdev->pdev->device == 0x9907) ||
 		    (rdev->pdev->device == 0x9908) ||
 		    (rdev->pdev->device == 0x9909) ||
+		    (rdev->pdev->device == 0x990B) ||
+		    (rdev->pdev->device == 0x990C) ||
+		    (rdev->pdev->device == 0x990F) ||
 		    (rdev->pdev->device == 0x9910) ||
-		    (rdev->pdev->device == 0x9917)) {
+		    (rdev->pdev->device == 0x9917) ||
+		    (rdev->pdev->device == 0x9999)) {
 			rdev->config.cayman.max_simds_per_se = 6;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9903) ||
 			   (rdev->pdev->device == 0x9904) ||
 			   (rdev->pdev->device == 0x990A) ||
+			   (rdev->pdev->device == 0x990D) ||
+			   (rdev->pdev->device == 0x990E) ||
 			   (rdev->pdev->device == 0x9913) ||
 			   (rdev->pdev->device == 0x9918)) {
 			rdev->config.cayman.max_simds_per_se = 4;
@@ -481,6 +487,9 @@ static void cayman_gpu_init(struct radeo
 			   (rdev->pdev->device == 0x9990) ||
 			   (rdev->pdev->device == 0x9991) ||
 			   (rdev->pdev->device == 0x9994) ||
+			   (rdev->pdev->device == 0x9995) ||
+			   (rdev->pdev->device == 0x9996) ||
+			   (rdev->pdev->device == 0x999A) ||
 			   (rdev->pdev->device == 0x99A0)) {
 			rdev->config.cayman.max_simds_per_se = 3;
 			rdev->config.cayman.max_backends_per_se = 1;


