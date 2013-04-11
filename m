Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935642Ab3DKVRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:17:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935524Ab3DKUs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:58 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=juXJV0cZH64A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_4ZhCcN7OKIA:10 a=pGLkceISAAAA:8 a=myVwGOACAAAA:8 a=VwQbUJbxAAAA:8 a=0e1NNH2jAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=p5cQTkJONggA:10 a=MSl-tDqOz04A:10 a=hAwTiGD2l9QA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202608.772600190@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Hutter <hutter.eric@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 137/171 ] ARM: kirkwood: Fix chip-delay for GoFlex Net
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0137-ARM-kirkwood-Fix-chip-delay-for-GoFlex-Net.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Hutter <hutter.eric@gmail.com>

[ Upstream commit 2992714d431976c4b154875bd18ba61bf4df3b93 ]

This fixes "Too few good blocks within range" issues on GoFlex Net by setting
chip-delay to 40.

The basic problem was discussed at http://forum.doozan.com/read.php?2,7451

Signed-off-by: Eric Hutter <hutter.eric@gmail.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Cc: <stable@vger.kernel.org> # v3.6.x
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/boot/dts/kirkwood-goflexnet.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/kirkwood-goflexnet.dts b/arch/arm/boot/dts/kirkwood-goflexnet.dts
index 7c8238f..a66a8eb 100644
--- a/arch/arm/boot/dts/kirkwood-goflexnet.dts
+++ b/arch/arm/boot/dts/kirkwood-goflexnet.dts
@@ -22,6 +22,7 @@
 		};
 
 		nand@3000000 {
+			chip-delay = <40>;
 			status = "okay";
 
 			partition@0 {
-- 
1.7.10.4


