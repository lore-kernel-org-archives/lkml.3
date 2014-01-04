Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaADCn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:43:29 -0500
Received: from mout.gmx.net ([212.227.17.20]:52234 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbaADCnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:43:03 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 06/15] tpm: MAINTAINERS: Cleanup TPM Maintainers file
Date: Sat,  4 Jan 2014 03:44:40 +0100
Message-Id: <1388803489-13258-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:Kfc27g/kA4qZVV9DJmNW69pXQMujoLBvY3hT8tZ/UUjHwkOP5l1
 sdBSv2sNJLlN1cPxDFZiaFzOmk2QkmUs/2wTEfWkORXoTiBskl/KYCbSv9YrEKU5cUUGU3t
 vSJaJwqqtf9u3wq9/strYj1vAch937LVCwzKSxXhCutGBS6mAUtQL/Q8g8OR3vguqe5vhbx
 ZPqMLCO9XTUPZ/g1m2kLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <PeterHuewe@gmx.de>

- removing stale/inactive maintainers
- removing stale/outdated website
- regrouped maintainers

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 MAINTAINERS | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d5e4ff3..3924b10 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8729,14 +8729,10 @@ S:	Odd fixes
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
1.8.1.5

