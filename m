Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaJCVxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:53:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbaJCVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 016/238] drm/radeon: load the lm63 driver for an lm64 thermal chip.
Date: Fri,  3 Oct 2014 14:28:51 -0700
Message-Id: <20141003212914.182404669@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5dc355325b648dc9b4cf3bea4d968de46fd59215 upstream.

Looks like the lm63 driver supports the lm64 as well.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1955,7 +1955,7 @@ static const char *thermal_controller_na
 	"adm1032",
 	"adm1030",
 	"max6649",
-	"lm64",
+	"lm63", /* lm64 */
 	"f75375",
 	"asc7xxx",
 };
@@ -1966,7 +1966,7 @@ static const char *pp_lib_thermal_contro
 	"adm1032",
 	"adm1030",
 	"max6649",
-	"lm64",
+	"lm63", /* lm64 */
 	"f75375",
 	"RV6xx",
 	"RV770",


