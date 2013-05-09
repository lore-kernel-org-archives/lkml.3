Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3EIVB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:01:56 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33275
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab3EIVBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:01:54 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, mchehab@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, devel@linuxdriverproject.org
Subject: [PATCH] MAINTAINERS: update Hyper-V file list
Date: Thu,  9 May 2013 14:34:55 -0700
Message-Id: <1368135295-13355-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 MAINTAINERS |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..315a63c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3865,9 +3865,16 @@ M:	K. Y. Srinivasan <kys@microsoft.com>
 M:	Haiyang Zhang <haiyangz@microsoft.com>
 L:	devel@linuxdriverproject.org
 S:	Maintained
-F:	drivers/hv/
+F:	arch/x86/include/asm/mshyperv.h
+F:	arch/x86/include/uapi/asm/hyperv.h
+F:	arch/x86/kernel/cpu/mshyperv.c
 F:	drivers/hid/hid-hyperv.c
+F:	drivers/hv/
 F:	drivers/net/hyperv/
+F:	drivers/scsi/storvsc_drv.c
+F:	drivers/video/hyperv_fb.c
+F:	include/linux/hyperv.h
+F:	tools/hv/
 
 I2C OVER PARALLEL PORT
 M:	Jean Delvare <khali@linux-fr.org>
-- 
1.7.4.1

