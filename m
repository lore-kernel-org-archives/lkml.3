Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaDQTce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:32:34 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:42804 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:32:26 -0400
From: Doug Anderson <dianders@chromium.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Bill Richardson <wfrichar@chromium.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: cros_ec: cleanup: cros_ec.c is GPL licensed, like all the others.
Date: Thu, 17 Apr 2014 12:32:17 -0700
Message-Id: <1397763137-20552-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

This module has always been GPL licensed. It was just missing the explicit
declaration to avoid tainting the kernel.

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mfd/cros_ec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index 783fe2e..fae69b1 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -184,3 +184,6 @@ int cros_ec_resume(struct cros_ec_device *ec_dev)
 EXPORT_SYMBOL(cros_ec_resume);
 
 #endif
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ChromeOS EC core driver");
-- 
1.9.1.423.g4596e3a

