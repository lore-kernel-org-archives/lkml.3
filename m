Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaAWPBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:01:02 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:46575 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaAWPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:01:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, torvalds@linux-foundation.org, jeffm@suse.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] openfirmware: trivial: Standardise formatting of 'struct of_device_id' definition
Date: Thu, 23 Jan 2014 15:00:39 +0000
Message-Id: <1390489239-29001-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's commonly accepted that when defining a struct the '{' is appended
onto the first line. This helps when searching for the definition using
syntax similar to 'struct of_device_id {'.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mod_devicetable.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 45e9214..090e014 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -220,8 +220,7 @@ struct serio_device_id {
 /*
  * Struct used for matching a device
  */
-struct of_device_id
-{
+struct of_device_id {
 	char	name[32];
 	char	type[32];
 	char	compatible[128];
-- 
1.8.3.2

