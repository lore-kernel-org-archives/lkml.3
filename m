Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab3IBIzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37799 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab3IBIz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 37/58] ARM: at91/DT: fix at91sam9n12ek memory node
Date: Mon,  2 Sep 2013 09:54:22 +0100
Message-Id: <1378112083-9475-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit a57603ca2871ee0773b00839c1ea35c4a2d3eeb0 upstream.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/at91sam9n12ek.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index f4e43e3..84d8bdb 100644
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
1.8.3.2

