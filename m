Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3EBIt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:49:27 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:50205 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab3EBItX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:49:23 -0400
From: Daniel Tang <dt.tangr@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [RESEND PATCH] Remove trailing whitespace in arch/arm/Makefile
Date: Thu, 2 May 2013 18:49:14 +1000
Message-Id: <5B221EAE-1E99-4E15-9696-389B32057464@gmail.com>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 arch/arm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index ee4605f..479b209 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -313,7 +313,7 @@ define archhelp
   echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
   echo  '* xipImage      - XIP kernel image, if configured (arch/$(ARCH)/boot/xipImage)'
   echo  '  uImage        - U-Boot wrapped zImage'
-  echo  '  bootpImage    - Combined zImage and initial RAM disk' 
+  echo  '  bootpImage    - Combined zImage and initial RAM disk'
   echo  '                  (supply initrd image via make variable INITRD=<path>)'
   echo  '* dtbs          - Build device tree blobs for enabled boards'
   echo  '  install       - Install uncompressed kernel'
-- 
1.8.1.3