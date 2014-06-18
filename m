Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaFRSVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:21:54 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:33837 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaFRSVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:21:53 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/10] mfd: cros_ec: Fix the comment on cros_ec_remove()
Date: Wed, 18 Jun 2014 11:13:58 -0700
Message-Id: <1403115247-8853-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403115247-8853-1-git-send-email-dianders@chromium.org>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

This comment was incorrect, so update it.

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
Changes in v2: None

 include/linux/mfd/cros_ec.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
index 887ef4f..7e9fe6e 100644
--- a/include/linux/mfd/cros_ec.h
+++ b/include/linux/mfd/cros_ec.h
@@ -148,8 +148,7 @@ int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
 /**
  * cros_ec_remove - Remove a ChromeOS EC
  *
- * Call this to deregister a ChromeOS EC. After this you should call
- * cros_ec_free().
+ * Call this to deregister a ChromeOS EC, then clean up any private data.
  *
  * @ec_dev: Device to register
  * @return 0 if ok, -ve on error
-- 
2.0.0.526.g5318336

