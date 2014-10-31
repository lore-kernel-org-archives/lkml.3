Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006AbaJaGpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:45:50 -0400
Received: from ozlabs.org ([103.22.144.67]:47417 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759332AbaJaGph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:45:37 -0400
From: Michael Ellerman <mpe@ellerman.id.au>
To: jdelvare@suse.de, linux@roeck-us.net
Cc: lm-sensors@lm-sensors.org, <linux-kernel@vger.kernel.org>,
        neelegup@linux.vnet.ibm.com
Subject: [PATCH 2/2] hwmon: (ibmpowernv) Make the driver name more recognisable
Date: Fri, 31 Oct 2014 17:45:23 +1100
Message-Id: <1414737923-8227-2-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414737923-8227-1-git-send-email-mpe@ellerman.id.au>
References: <1414737923-8227-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing "ibmpowernv" in dmesg is not very useful, that is just the name
of the platform and doesn't identify the message as coming from the
hwmon driver.

Change DRVNAME to "powernv-hwmon" to make it clearer.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/hwmon/ibmpowernv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ibmpowernv.c b/drivers/hwmon/ibmpowernv.c
index 6a30eeea94be..3ee00928cda9 100644
--- a/drivers/hwmon/ibmpowernv.c
+++ b/drivers/hwmon/ibmpowernv.c
@@ -16,7 +16,7 @@
  * along with this program.
  */
 
-#define DRVNAME		"ibmpowernv"
+#define DRVNAME		"powernv-hwmon"
 #define pr_fmt(fmt)	DRVNAME ": " fmt
 
 #include <linux/init.h>
-- 
1.9.1

