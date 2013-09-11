Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3IKE6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3IKE4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:55 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=FwxVaEifRJgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Xidj-NKuuKUA:10 a=jAfPOIUMAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=gE_ZUhsuebIA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042929.019927968@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [221/251] ARM: at91/DT: fix at91sam9n12ek memory node
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0221-ARM-at91-DT-fix-at91sam9n12ek-memory-node.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

[ Upstream commit a57603ca2871ee0773b00839c1ea35c4a2d3eeb0 ]

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> # 3.5+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/boot/dts/at91sam9n12ek.dts |    4 ++--
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
1.7.10.4


