Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3FMQho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:37:44 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55713 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3FMQhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:37:43 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Dinh Nguyen <dinguyen@altera.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 1/4] arm: zynq: Remove board specific compatibility string
Date: Thu, 13 Jun 2013 09:37:15 -0700
Message-Id: <1371141438-16553-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371141438-16553-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1371141438-16553-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not necessary to have board specific compatibility strings
in the platform code. The board dts files can use the more generic
'xlnx,zynq-7000' string.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 5bfe703..7e3d5f4 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -98,7 +98,6 @@ static void zynq_system_reset(char mode, const char *cmd)
 }
 
 static const char * const zynq_dt_match[] = {
-	"xlnx,zynq-zc702",
 	"xlnx,zynq-7000",
 	NULL
 };
-- 
1.8.3

