Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3IEPwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:52:03 -0400
Received: from mail-pa0-f66.google.com ([209.85.220.66]:64746 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3IEPwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:52:00 -0400
Date: Thu, 5 Sep 2013 21:21:54 +0530
From: Avi <avi.kp.137@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: klmckinney1@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: drivers/staging/bcm/InterfaceMisc.c-checkpatch cleanup-(foo*)->(foo
 *)
Message-ID: <20130905155154.GA7535@avi-VPCCW15FG>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


--NzB8fVQJ5HfG6fxh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-drivers-staging-bcm-InterfaceMisc.c-107-ERROR-foo-sh.patch"

>From 91e1d42ce8b52cc28689ea4e56c71b790217cf91 Mon Sep 17 00:00:00 2001
From: AVI <avi@avi-VPCCW15FG.(none)>
Date: Thu, 5 Sep 2013 21:03:45 +0530
Subject: [PATCH] drivers/staging/bcm/InterfaceMisc.c:107: ERROR: "(foo*)"
 should be "(foo *)" 
Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>

---
 drivers/staging/bcm/InterfaceMisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/InterfaceMisc.c b/drivers/staging/bcm/InterfaceMisc.c
index afca010..d9fa2bb 100644
--- a/drivers/staging/bcm/InterfaceMisc.c
+++ b/drivers/staging/bcm/InterfaceMisc.c
@@ -104,7 +104,7 @@ int BcmRDM(void *arg,
 	void *buff,
 	int len)
 {
-	return InterfaceRDM((struct bcm_interface_adapter*)arg, addr, buff, len);
+	return InterfaceRDM((struct bcm_interface_adapter *)arg, addr, buff, len);
 }
 
 int BcmWRM(void *arg,
-- 
1.7.10.4


--NzB8fVQJ5HfG6fxh--
