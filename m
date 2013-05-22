Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3EVP7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:59:42 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33211 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab3EVP7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:59:39 -0400
Date: Wed, 22 May 2013 10:56:58 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: James Morris <jmorris@namei.org>, tpmdd-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Subject: [PATCH] maintainers: Remove Kent from maintainers
Message-ID: <20130522155658.GA3740@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052215-5806-0000-0000-000021436959
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 MAINTAINERS | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 829c032..592af73 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3971,7 +3971,8 @@ S:	Maintained
 F:	arch/ia64/
 
 IBM Power in-Nest Crypto Acceleration
-M:	Kent Yoder <key@linux.vnet.ibm.com>
+M:	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
+M:	Fionnuala Gunter <fin@linux.vnet.ibm.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/nx/
@@ -8212,7 +8213,8 @@ S:	Odd fixes
 F:	drivers/media/usb/tm6000/
 
 TPM DEVICE DRIVER
-M:	Kent Yoder <key@linux.vnet.ibm.com>
+M:	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
+M:	Ashley Lai <ashley@ashleylai.com>
 M:	Rajiv Andrade <mail@srajiv.net>
 W:	http://tpmdd.sourceforge.net
 M:	Marcel Selhorst <tpmdd@selhorst.net>
-- 
1.7.11.7

