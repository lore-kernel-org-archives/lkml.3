Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3J3TvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:51:19 -0400
Received: from mout.gmx.net ([212.227.15.15]:64361 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab3J3TvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:51:15 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Sirrix AG <tpmdd@sirrix.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Joel Schopp <jschopp@linux.vnet.ibm.com>
Subject: [PATCH] tpm: MAINTAINERS: Cleanup TPM Maintainers file
Date: Wed, 30 Oct 2013 20:54:45 +0100
Message-Id: <1383162885-5140-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Provags-ID: V03:K0:niTUyo6B3uc0a46/LXqTPkH+R5elj1W6tGQSYqd2L/zqgeKIc1/
 KfcQtF4FCUzBu7hfRBFYhCfzVovhaBFKfMLmNn8FNN0VTPJ2KWQtsRyCe29IIBkMIEodev7
 xbYwHa1H/D77jpvFqTaOzrCG7tlF24eg2pJw0qBf6iTIp/HGQHhYMVd4B0QEF21AmA/7pJQ
 u+otVFL7bsiSopmwb7ZCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- removing stale/inactive maintainers
- removing stale/outdated website
- regrouped maintainers

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
@to-recipients: please provide a signed-off/acked-by in a timely fashion

 MAINTAINERS |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 936adb4..0f42b97 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8473,14 +8473,10 @@ S:	Odd fixes
 F:	drivers/media/usb/tm6000/
 
 TPM DEVICE DRIVER
-M:	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
-M:	Ashley Lai <ashley@ashleylai.com>
 M:	Peter Huewe <peterhuewe@gmx.de>
-M:	Rajiv Andrade <mail@srajiv.net>
-W:	http://tpmdd.sourceforge.net
+M:	Ashley Lai <ashley@ashleylai.com>
 M:	Marcel Selhorst <tpmdd@selhorst.net>
-M:	Sirrix AG <tpmdd@sirrix.com>
-W:	http://www.sirrix.com
+W:	http://tpmdd.sourceforge.net
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/char/tpm/
-- 
1.7.8.6

