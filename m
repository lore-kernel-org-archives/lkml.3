Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaG2NfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:35:19 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:52915 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaG2NfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:35:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] MAINTAINERS: Update MFD repo location
Date: Tue, 29 Jul 2014 14:34:45 +0100
Message-Id: <1406640885-20481-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old one hasn't been used for well over 6 months.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61a8f48..676372b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6002,8 +6002,7 @@ F:	include/media/mt9v032.h
 MULTIFUNCTION DEVICES (MFD)
 M:	Samuel Ortiz <sameo@linux.intel.com>
 M:	Lee Jones <lee.jones@linaro.org>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git
 S:	Supported
 F:	drivers/mfd/
 F:	include/linux/mfd/
-- 
1.9.1

