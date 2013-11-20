Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3KTVaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:30:13 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:50809
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab3KTVaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:30:12 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 16:30:12 EST
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: akpm@linux-foundation.org, m.chehab@samsung.com, cesarb@cesarb.net,
        gregkh@linuxfoundation.org, joe@perches.com,
        linux-kernel@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, devel@linuxdriverproject.org
Subject: [PATCH] MAINTAINERS: add keyboard driver to Hyper-V file list
Date: Wed, 20 Nov 2013 14:07:25 -0800
Message-Id: <1384985245-25718-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 167e188..8285ed4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4065,6 +4065,7 @@ F:	arch/x86/include/uapi/asm/hyperv.h
 F:	arch/x86/kernel/cpu/mshyperv.c
 F:	drivers/hid/hid-hyperv.c
 F:	drivers/hv/
+F:	drivers/input/serio/hyperv-keyboard.c
 F:	drivers/net/hyperv/
 F:	drivers/scsi/storvsc_drv.c
 F:	drivers/video/hyperv_fb.c
-- 
1.7.4.1

