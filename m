Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab3GDHTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:19:35 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27091 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933644Ab3GDHTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:19:30 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 2/4] arm: atmel: include sama5d3.h into hardware.h
Date: Thu,  4 Jul 2013 15:16:40 +0800
Message-Id: <1372922202-28606-3-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
References: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include sama5d3.h into hardware.h

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/mach-at91/include/mach/hardware.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
index a832e07..f17aa31 100644
--- a/arch/arm/mach-at91/include/mach/hardware.h
+++ b/arch/arm/mach-at91/include/mach/hardware.h
@@ -33,6 +33,7 @@
 #include <mach/at91sam9g45.h>
 #include <mach/at91sam9x5.h>
 #include <mach/at91sam9n12.h>
+#include <mach/sama5d3.h>
 
 /*
  * On all at91 except rm9200 and x40 have the System Controller starts
-- 
1.7.9.5

