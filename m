Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab3ICQcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:32:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46606 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab3ICQ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:28:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 38/58] ARM: at91/DT: fix at91sam9n12ek memory node
Date: Tue,  3 Sep 2013 09:23:42 -0700
Message-Id: <1378225442-20654-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit a57603ca2871ee0773b00839c1ea35c4a2d3eeb0 upstream.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/at91sam9n12ek.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index 0376bf4..9afa488 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -14,11 +14,11 @@
 	compatible = "atmel,at91sam9n12ek", "atmel,at91sam9n12", "atmel,at91sam9";
 
 	chosen {
-		bootargs = "mem=128M console=ttyS0,115200 root=/dev/mtdblock1 rw rootfstype=jffs2";
+		bootargs = "console=ttyS0,115200 root=/dev/mtdblock1 rw rootfstype=jffs2";
 	};
 
 	memory {
-		reg = <0x20000000 0x10000000>;
+		reg = <0x20000000 0x8000000>;
 	};
 
 	clocks {
-- 
1.8.1.2

