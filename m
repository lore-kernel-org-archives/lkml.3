Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaBGM33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:29:29 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56038 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaBGM2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:28:38 -0500
Date: Fri, 7 Feb 2014 17:58:32 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 09/26] drivers: isdn: Include appropriate header file in
 diva.c
Message-ID: <d1f2a6a9c34f0e96cd2d24cd240f334a48864cff.1390408516.git.rashika.kheria@gmail.com>
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file helpers.h in hardware/eicon/diva.c
because it defines function declared in the header file.

This eliminates the following warning in hardware/eicon/diva.c:
drivers/isdn/hardware/eicon/diva.c:655:6: warning: no previous prototype for ‘xdiFreeFile’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/diva.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/isdn/hardware/eicon/diva.c b/drivers/isdn/hardware/eicon/diva.c
index d91dd58..6f28797 100644
--- a/drivers/isdn/hardware/eicon/diva.c
+++ b/drivers/isdn/hardware/eicon/diva.c
@@ -17,6 +17,7 @@
 #include "xdi_adapter.h"
 #include "diva_pci.h"
 #include "diva.h"
+#include "helpers.h"
 
 #ifdef CONFIG_ISDN_DIVAS_PRIPCI
 #include "os_pri.h"
-- 
1.7.9.5

