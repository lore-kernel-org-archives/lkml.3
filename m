Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab3EVTZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:25:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45165 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3EVTZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:25:49 -0400
Date: Wed, 22 May 2013 14:23:06 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com,
        James Morris <jmorris@namei.org>
Subject: [PATCHv2] maintainers: remove Kent from maintainers list
Message-ID: <20130522192306.GA29733@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052219-3620-0000-0000-000002A1ECC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
v2: Replace Kent with other so that NX isn't unmaintained,
    leave tpmdd-devel as maintainer for TPM

 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 829c032..5ec293d 100644
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
@@ -8212,7 +8213,6 @@ S:	Odd fixes
 F:	drivers/media/usb/tm6000/
 
 TPM DEVICE DRIVER
-M:	Kent Yoder <key@linux.vnet.ibm.com>
 M:	Rajiv Andrade <mail@srajiv.net>
 W:	http://tpmdd.sourceforge.net
 M:	Marcel Selhorst <tpmdd@selhorst.net>
-- 
1.7.11.7

